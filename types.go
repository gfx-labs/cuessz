package cuessz

import (
	"errors"
	"fmt"
)

// Sentinel errors for schema validation
var (
	// ErrRecursiveType indicates a recursive type reference was detected
	ErrRecursiveType = errors.New("recursive type reference detected")
)

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

// Def represents an SSZ type definition (matches CUE #Def)
type Def struct {
	Type TypeName `json:"type" yaml:"type"`

	Description *string `json:"description,omitempty" yaml:"description,omitempty"`

	Size  uint64 `json:"size,omitempty" yaml:"size,omitempty"`
	Limit uint64 `json:"limit,omitempty" yaml:"limit,omitempty"`

	Ref      string  `json:"ref,omitempty" yaml:"ref,omitempty"`
	Children []Field `json:"children,omitempty" yaml:"children,omitempty"`

	ActiveFields []int `json:"active_fields,omitempty" yaml:"active_fields,omitempty"`
}

// Field represents a named field within a container (matches CUE #Field)
type Field struct {
	Name        string  `json:"name" yaml:"name"`
	Def         Def     `json:"def" yaml:"def"`
	Description *string `json:"description,omitempty" yaml:"description,omitempty"`
}

// IsVariable determines if a def is variable-size
func (d *Def) IsVariable(refs map[string]Def) (bool, error) {
	const maxIterations = 1000 // Sanity check to prevent infinite recursion
	return isVariable(d, refs, 0, maxIterations)
}

// isVariable is the internal implementation with iteration tracking
func isVariable(d *Def, refs map[string]Def, iterations, maxIterations int) (bool, error) {
	if iterations >= maxIterations {
		return false, fmt.Errorf("max iterations reached while checking IsVariable - possible circular reference")
	}

	switch d.Type {
	case TypeList, TypeBitList, TypeUnion:
		return true, nil
	case TypeProgressiveContainer, TypeContainer, TypeVector, TypeBitVector:
		// Progressive/regular containers and vectors are variable-size only if they contain variable-size children
		// The active_fields bitvector in progressive containers affects merkleization, not serialization
		for _, child := range d.Children {
			isVar, err := isVariable(&child.Def, refs, iterations+1, maxIterations)
			if err != nil {
				return false, err
			}
			if isVar {
				return true, nil
			}
		}
	case TypeRef:
		if d.Ref == "" {
			return false, fmt.Errorf("def has type 'ref' but no ref specified")
		}
		refDef, ok := refs[d.Ref]
		if !ok {
			return false, fmt.Errorf("ref type '%s' not found", d.Ref)
		}
		return isVariable(&refDef, refs, iterations+1, maxIterations)
	}
	return false, nil
}

// Note: Validation is now handled by CUE schema in ssz_schema.cue
// The IsValid method has been removed to avoid redundant validation

// Schema represents a collection of named SSZ type definitions
type Schema struct {
	Version  string         `json:"version" yaml:"version"`
	Defs     map[string]Def `json:"defs" yaml:"defs"`
	Metadata *Metadata      `json:"metadata,omitempty" yaml:"metadata,omitempty"`
}

// Metadata contains optional schema metadata
type Metadata struct {
	Namespace   string   `json:"namespace,omitempty" yaml:"namespace,omitempty"`
	Description string   `json:"description,omitempty" yaml:"description,omitempty"`
	Authors     []string `json:"authors,omitempty" yaml:"authors,omitempty"`
}

// Validate validates all defs in the schema
func (s *Schema) Validate() error {
	if s.Defs == nil {
		return fmt.Errorf("schema defs cannot be nil")
	}

	return nil
}
