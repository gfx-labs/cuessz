package cuessz

import "fmt"

// TypeName represents the type discriminator for SSZ types
type TypeName string

const (
	TypeUint8   TypeName = "uint8"
	TypeUint16  TypeName = "uint16"
	TypeUint32  TypeName = "uint32"
	TypeUint64  TypeName = "uint64"
	TypeUint128 TypeName = "uint128"
	TypeUint256 TypeName = "uint256"

	TypeBoolean TypeName = "boolean"

	TypeContainer            TypeName = "container"
	TypeProgressiveContainer TypeName = "progressive_container"

	TypeVector TypeName = "vector"
	TypeList   TypeName = "list"

	TypeBitVector TypeName = "bitvector"
	TypeBitList   TypeName = "bitlist"

	TypeUnion TypeName = "union"

	// TypeRef is a special type that references another type in the schema
	TypeRef TypeName = "ref"
)

func (t TypeName) String() string {
	return string(t)
}

func (t TypeName) IsSometimesVariable() bool {
	switch t {
	case TypeVector, TypeContainer, TypeProgressiveContainer, TypeUnion, TypeRef:
		return true
	default:
		return false
	}
}

func (t TypeName) IsAlwaysVariable() bool {
	switch t {
	case TypeList, TypeBitList:
		return true
	default:
		return false
	}
}

func (t TypeName) IsAlwaysFixed() bool {
	switch t {
	case TypeUint8, TypeUint16, TypeUint32, TypeUint64, TypeUint128, TypeUint256, TypeBoolean, TypeBitVector:
		return true
	default:
		return false
	}
}

// Field represents an SSZ type or field definition
type Field struct {
	Name string   `json:"name" yaml:"name"`
	Type TypeName `json:"type" yaml:"type"`

	Size  uint64 `json:"size,omitempty" yaml:"size,omitempty"`
	Limit uint64 `json:"limit,omitempty" yaml:"limit,omitempty"` // Not used for progressive_container (always 256)

	Ref      string  `json:"ref,omitempty" yaml:"ref,omitempty"`
	Children []Field `json:"children,omitempty" yaml:"children,omitempty"`

	ActiveFields []int `json:"active_fields,omitempty" yaml:"active_fields,omitempty"`
}

// IsVariable determines if a field is variable-size
func (f *Field) IsVariable(refs map[string]Field) (bool, error) {
	const maxIterations = 1000 // Sanity check to prevent infinite recursion
	return isVariable(f, refs, 0, maxIterations)
}

// isVariable is the internal implementation with iteration tracking
func isVariable(f *Field, refs map[string]Field, iterations, maxIterations int) (bool, error) {
	if iterations >= maxIterations {
		return false, fmt.Errorf("max iterations reached while checking IsVariable - possible circular reference")
	}

	switch f.Type {
	case TypeList, TypeBitList, TypeUnion:
		return true, nil
	case TypeProgressiveContainer, TypeContainer, TypeVector, TypeBitVector:
		// Progressive/regular containers and vectors are variable-size only if they contain variable-size children
		// The active_fields bitvector in progressive containers affects merkleization, not serialization
		for _, child := range f.Children {
			isVar, err := isVariable(&child, refs, iterations+1, maxIterations)
			if err != nil {
				return false, err
			}
			if isVar {
				return true, nil
			}
		}
	case TypeRef:
		if f.Ref == "" {
			return false, fmt.Errorf("field has type 'ref' but no ref specified")
		}
		refField, ok := refs[f.Ref]
		if !ok {
			return false, fmt.Errorf("ref type '%s' not found", f.Ref)
		}
		return isVariable(&refField, refs, iterations+1, maxIterations)
	}
	return false, nil
}

// IsValid validates the field and all its subfields
func (f *Field) IsValid(refs map[string]Field) error {
	const maxIterations = 1000 // Sanity check to prevent infinite recursion
	return isValid(f, refs, 0, maxIterations)
}

// isValid is the internal implementation with iteration tracking
func isValid(f *Field, refs map[string]Field, iterations, maxIterations int) error {
	if iterations >= maxIterations {
		return fmt.Errorf("max iterations reached while validating field '%s' - possible circular reference", f.Name)
	}

	// Validate field name
	if f.Name == "" {
		return fmt.Errorf("field name cannot be empty")
	}

	// Validate based on type
	switch f.Type {
	case TypeUint8, TypeUint16, TypeUint32, TypeUint64, TypeUint128, TypeUint256, TypeBoolean:
		// Basic types should not have extra fields
		if f.Size != 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have size specified", f.Name, f.Type)
		}
		if f.Limit != 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have limit specified", f.Name, f.Type)
		}
		if f.Ref != "" {
			return fmt.Errorf("field '%s' of type '%s' should not have ref specified", f.Name, f.Type)
		}
		if len(f.Children) > 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have children", f.Name, f.Type)
		}
		if len(f.ActiveFields) > 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have active_fields", f.Name, f.Type)
		}
		return nil

	case TypeVector, TypeBitVector:
		// Fixed-size types must have Size specified
		if f.Size == 0 {
			return fmt.Errorf("field '%s' of type '%s' must have non-zero size", f.Name, f.Type)
		}
		// Should not have inappropriate fields
		if f.Limit != 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have limit specified", f.Name, f.Type)
		}
		if f.Ref != "" {
			return fmt.Errorf("field '%s' of type '%s' should not have ref specified", f.Name, f.Type)
		}
		if len(f.ActiveFields) > 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have active_fields", f.Name, f.Type)
		}
		// Validate children for container vectors
		if f.Type == TypeVector && len(f.Children) > 0 {
			for i, child := range f.Children {
				if err := isValid(&child, refs, iterations+1, maxIterations); err != nil {
					return fmt.Errorf("field '%s' child[%d]: %w", f.Name, i, err)
				}
			}
		}
		return nil

	case TypeList, TypeBitList:
		// Variable-size types must have Limit specified
		if f.Limit == 0 {
			return fmt.Errorf("field '%s' of type '%s' must have non-zero limit", f.Name, f.Type)
		}
		// Should not have inappropriate fields
		if f.Size != 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have size specified", f.Name, f.Type)
		}
		if f.Ref != "" {
			return fmt.Errorf("field '%s' of type '%s' should not have ref specified", f.Name, f.Type)
		}
		if len(f.ActiveFields) > 0 {
			return fmt.Errorf("field '%s' of type '%s' should not have active_fields", f.Name, f.Type)
		}
		// Validate children for container lists
		if f.Type == TypeList && len(f.Children) > 0 {
			for i, child := range f.Children {
				if err := isValid(&child, refs, iterations+1, maxIterations); err != nil {
					return fmt.Errorf("field '%s' child[%d]: %w", f.Name, i, err)
				}
			}
		}
		return nil

	case TypeContainer:
		// Containers must have children
		if len(f.Children) == 0 {
			return fmt.Errorf("field '%s' of type 'container' must have children", f.Name)
		}
		// Should not have inappropriate fields
		if f.Size != 0 {
			return fmt.Errorf("field '%s' of type 'container' should not have size specified", f.Name)
		}
		if f.Limit != 0 {
			return fmt.Errorf("field '%s' of type 'container' should not have limit specified", f.Name)
		}
		if f.Ref != "" {
			return fmt.Errorf("field '%s' of type 'container' should not have ref specified", f.Name)
		}
		if len(f.ActiveFields) > 0 {
			return fmt.Errorf("field '%s' of type 'container' should not have active_fields (use 'progressive_container' instead)", f.Name)
		}
		// Validate all children
		for i, child := range f.Children {
			if err := isValid(&child, refs, iterations+1, maxIterations); err != nil {
				return fmt.Errorf("field '%s' child[%d]: %w", f.Name, i, err)
			}
		}
		return nil

	case TypeProgressiveContainer:
		// Progressive containers must have children
		if len(f.Children) == 0 {
			return fmt.Errorf("field '%s' of type 'progressive_container' must have children", f.Name)
		}
		// Should not have inappropriate fields
		if f.Size != 0 {
			return fmt.Errorf("field '%s' of type 'progressive_container' should not have size specified", f.Name)
		}
		if f.Ref != "" {
			return fmt.Errorf("field '%s' of type 'progressive_container' should not have ref specified", f.Name)
		}
		// active_fields bitset must be specified
		if len(f.ActiveFields) == 0 {
			return fmt.Errorf("field '%s' of type 'progressive_container' must have active_fields bitset specified", f.Name)
		}
		// active_fields must not exceed 256 entries
		if len(f.ActiveFields) > 256 {
			return fmt.Errorf("field '%s' of type 'progressive_container' has active_fields length %d but max is 256", f.Name, len(f.ActiveFields))
		}
		// active_fields must not end in 0
		if f.ActiveFields[len(f.ActiveFields)-1] == 0 {
			return fmt.Errorf("field '%s' of type 'progressive_container' has active_fields ending in 0 (illegal)", f.Name)
		}
		// Validate and count active fields
		activeCount := 0
		for i, active := range f.ActiveFields {
			if active != 0 && active != 1 {
				return fmt.Errorf("field '%s' of type 'progressive_container' has invalid active_fields[%d]=%d (must be 0 or 1)", f.Name, i, active)
			}
			if active == 1 {
				activeCount++
			}
		}
		// Count of 1s must match number of children
		if activeCount != len(f.Children) {
			return fmt.Errorf("field '%s' of type 'progressive_container' has %d active fields (1s) but %d children", f.Name, activeCount, len(f.Children))
		}
		// Validate all children
		for i, child := range f.Children {
			if err := isValid(&child, refs, iterations+1, maxIterations); err != nil {
				return fmt.Errorf("field '%s' child[%d]: %w", f.Name, i, err)
			}
		}
		return nil

	case TypeUnion:
		// Unions must have children
		if len(f.Children) == 0 {
			return fmt.Errorf("field '%s' of type 'union' must have children", f.Name)
		}
		// Should not have inappropriate fields
		if f.Size != 0 {
			return fmt.Errorf("field '%s' of type 'union' should not have size specified", f.Name)
		}
		if f.Limit != 0 {
			return fmt.Errorf("field '%s' of type 'union' should not have limit specified", f.Name)
		}
		if f.Ref != "" {
			return fmt.Errorf("field '%s' of type 'union' should not have ref specified", f.Name)
		}
		if len(f.ActiveFields) > 0 {
			return fmt.Errorf("field '%s' of type 'union' should not have active_fields", f.Name)
		}
		// Validate all children
		for i, child := range f.Children {
			if err := isValid(&child, refs, iterations+1, maxIterations); err != nil {
				return fmt.Errorf("field '%s' child[%d]: %w", f.Name, i, err)
			}
		}
		return nil

	case TypeRef:
		// Refs must have a reference
		if f.Ref == "" {
			return fmt.Errorf("field '%s' has type 'ref' but no ref specified", f.Name)
		}
		// Should not have inappropriate fields
		if f.Size != 0 {
			return fmt.Errorf("field '%s' of type 'ref' should not have size specified", f.Name)
		}
		if f.Limit != 0 {
			return fmt.Errorf("field '%s' of type 'ref' should not have limit specified", f.Name)
		}
		if len(f.Children) > 0 {
			return fmt.Errorf("field '%s' of type 'ref' should not have children", f.Name)
		}
		if len(f.ActiveFields) > 0 {
			return fmt.Errorf("field '%s' of type 'ref' should not have active_fields", f.Name)
		}
		// Check if ref exists
		refField, ok := refs[f.Ref]
		if !ok {
			return fmt.Errorf("field '%s' references type '%s' which is not found", f.Name, f.Ref)
		}
		// Validate the referenced field
		return isValid(&refField, refs, iterations+1, maxIterations)

	default:
		return fmt.Errorf("field '%s' has unknown type '%s'", f.Name, f.Type)
	}
}

// Schema represents a collection of named SSZ type definitions
type Schema struct {
	Version  string           `json:"version" yaml:"version"`
	Types    map[string]Field `json:"types" yaml:"types"`
	Metadata *Metadata        `json:"metadata,omitempty" yaml:"metadata,omitempty"`
}

// Metadata contains optional schema metadata
type Metadata struct {
	Namespace   string   `json:"namespace,omitempty" yaml:"namespace,omitempty"`
	Description string   `json:"description,omitempty" yaml:"description,omitempty"`
	Authors     []string `json:"authors,omitempty" yaml:"authors,omitempty"`
}

// Validate validates all types in the schema
func (s *Schema) Validate() error {
	if s.Types == nil {
		return fmt.Errorf("schema types cannot be nil")
	}

	for name, field := range s.Types {
		if field.Name != name {
			return fmt.Errorf("type '%s' has mismatched name field '%s'", name, field.Name)
		}
		if err := field.IsValid(s.Types); err != nil {
			return fmt.Errorf("type '%s' validation failed: %w", name, err)
		}
	}

	return nil
}
