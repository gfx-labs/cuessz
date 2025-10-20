package cuessz

import (
	_ "embed"
	"encoding/json"
	"errors"
	"fmt"
	"strings"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/ast"
	"cuelang.org/go/cue/cuecontext"
	cueErrors "cuelang.org/go/cue/errors"
)

var (
	// ErrCUEValidation indicates the schema failed CUE validation
	ErrCUEValidation = errors.New("CUE schema validation failed")

	// maxCycleDepth is the maximum depth for cycle detection using CUE API
	maxCycleDepth = 1000
)

//go:embed ssz_schema.cue
var sszSchemaCUE string

// ParseJSON parses and validates a JSON schema against the CUE schema definition
// Consumers should convert YAML to JSON before calling this function
func ParseJSON(data []byte) (*Schema, error) {
	ctx := cuecontext.New()

	// Load the CUE schema
	schemaValue := ctx.CompileString(sszSchemaCUE)
	if schemaValue.Err() != nil {
		return nil, fmt.Errorf("failed to compile CUE schema: %w", schemaValue.Err())
	}

	// Parse the JSON data into CUE
	dataValue := ctx.CompileBytes(data)
	if dataValue.Err() != nil {
		return nil, fmt.Errorf("failed to parse JSON: %w", dataValue.Err())
	}

	// Validate against #Schema
	schemaType := schemaValue.LookupPath(cue.ParsePath("#Schema"))
	if schemaType.Err() != nil {
		return nil, fmt.Errorf("failed to find #Schema in CUE schema: %w", schemaType.Err())
	}

	// Unify the data with the schema type
	unified := schemaType.Unify(dataValue)
	if err := unified.Validate(cue.Concrete(true)); err != nil {
		// Improve error messages for common cases (pass dataValue to get original values)
		return nil, fmt.Errorf("%w: %w", ErrCUEValidation, EnhanceCUEError(err, dataValue))
	}

	// Check for cycles using CUE API before parsing to Go
	if err := checkCyclesWithCUE(unified); err != nil {
		return nil, err
	}

	// Check that all refs point to valid top-level defs
	if err := checkRefsWithCUE(unified); err != nil {
		return nil, err
	}

	// Parse into Go struct
	var schema Schema
	if err := json.Unmarshal(data, &schema); err != nil {
		return nil, fmt.Errorf("failed to unmarshal into Go struct: %w", err)
	}

	// Also run Go-side validation for additional checks (field validation, etc.)
	if err := schema.Validate(); err != nil {
		return nil, fmt.Errorf("Go validation failed: %w", err)
	}

	return &schema, nil
}

// EnhanceCUEError improves CUE error messages for common validation failures using CUE's error API
func EnhanceCUEError(err error, schemaValue cue.Value) error {
	errMsg := err.Error()

	// Check for invalid type errors (e.g., "empty disjunction" on .type field)
	if strings.Contains(errMsg, "empty disjunction") && strings.Contains(errMsg, ".type:") {
		// Use CUE's error API to extract structured error information
		errs := cueErrors.Errors(err)
		if len(errs) == 0 {
			return err
		}

		// Look for the first error with a path that ends in "type"
		for _, e := range errs {
			path := cueErrors.Path(e)

			// Check if this is a type error - path should contain "defs" and end with "type"
			if len(path) >= 3 && path[len(path)-1] == "type" {
				// Find the def name - it's the element after "defs"
				defIdx := -1
				for i, p := range path {
					if p == "defs" && i+1 < len(path) {
						defIdx = i + 1
						break
					}
				}

				if defIdx == -1 {
					continue
				}

				defName := path[defIdx]

				// Try to get the actual invalid type value
				// First try the full path from the error (works for CUE files with constraints)
				pathStr := strings.Join(path, ".")
				typeValue := schemaValue.LookupPath(cue.ParsePath(pathStr))

				// If that doesn't exist, try a direct path (works for JSON files)
				if !typeValue.Exists() {
					defsPath := "defs." + defName + ".type"
					typeValue = schemaValue.LookupPath(cue.ParsePath(defsPath))
				}

				if typeValue.Exists() {
					// First try to get the value as a string (works for JSON and simple CUE values)
					if typeStr, err := typeValue.String(); err == nil && typeStr != "" && !strings.Contains(typeStr, "_|_") {
						return fmt.Errorf("def '%s' has invalid type '%s' - must be one of: uint8, uint16, uint32, uint64, uint128, uint256, boolean, container, progressive_container, vector, list, bitvector, bitlist, union, ref",
							defName, typeStr)
					}

					// Try to get the source syntax (for CUE files with constraints)
					syntax := typeValue.Syntax(cue.Raw())
					if syntax != nil {
						// Check if it's a basic literal (string)
						if lit, ok := syntax.(*ast.BasicLit); ok {
							typeStr := strings.Trim(lit.Value, "\"")
							if typeStr != "" && !strings.Contains(typeStr, "_|_") {
								return fmt.Errorf("def '%s' has invalid type '%s' - must be one of: uint8, uint16, uint32, uint64, uint128, uint256, boolean, container, progressive_container, vector, list, bitvector, bitlist, union, ref",
									defName, typeStr)
							}
						} else if binExpr, ok := syntax.(*ast.BinaryExpr); ok {
							// Binary expression - constraint & value
							if structLit, ok := binExpr.Y.(*ast.StructLit); ok {
								if len(structLit.Elts) > 0 {
									// Check if it's an embedded value
									if embedDecl, ok := structLit.Elts[0].(*ast.EmbedDecl); ok {
										if lit, ok := embedDecl.Expr.(*ast.BasicLit); ok {
											typeStr := strings.Trim(lit.Value, "\"")
											if typeStr != "" && !strings.Contains(typeStr, "_|_") {
												return fmt.Errorf("def '%s' has invalid type '%s' - must be one of: uint8, uint16, uint32, uint64, uint128, uint256, boolean, container, progressive_container, vector, list, bitvector, bitlist, union, ref",
													defName, typeStr)
											}
										}
									} else if field, ok := structLit.Elts[0].(*ast.Field); ok {
										// Check if the label is a basic literal
										if labelLit, ok := field.Label.(*ast.BasicLit); ok {
											typeStr := strings.Trim(labelLit.Value, "\"")
											if typeStr != "" && !strings.Contains(typeStr, "_|_") {
												return fmt.Errorf("def '%s' has invalid type '%s' - must be one of: uint8, uint16, uint32, uint64, uint128, uint256, boolean, container, progressive_container, vector, list, bitvector, bitlist, union, ref",
													defName, typeStr)
											}
										}
									}
								}
							}
						}
					}
				}

				return fmt.Errorf("def '%s' has invalid type - must be one of: uint8, uint16, uint32, uint64, uint128, uint256, boolean, container, progressive_container, vector, list, bitvector, bitlist, union, ref",
					defName)
			}
		}
	}

	// Return original error if we can't enhance it
	return err
}

// checkCyclesWithCUE uses the CUE API to detect cycles in type references
func checkCyclesWithCUE(schemaValue cue.Value) error {
	// Get the defs field
	defsValue := schemaValue.LookupPath(cue.ParsePath("defs"))
	if defsValue.Err() != nil {
		return fmt.Errorf("failed to lookup defs: %w", defsValue.Err())
	}

	// Build a map of def names for quick lookup
	defNames := make(map[string]bool)
	iter, err := defsValue.Fields(cue.Definitions(true))
	if err != nil {
		return fmt.Errorf("failed to iterate defs: %w", err)
	}
	for iter.Next() {
		defNames[iter.Label()] = true
	}

	// Check each def for cycles
	iter, err = defsValue.Fields(cue.Definitions(true))
	if err != nil {
		return fmt.Errorf("failed to iterate defs: %w", err)
	}
	for iter.Next() {
		defName := iter.Label()
		defValue := iter.Value()

		visited := make(map[string]bool)
		path := make(map[string]bool)
		if cycle := detectCycleInCUE(defName, defValue, defsValue, visited, path, 0); cycle != nil {
			// Format cycle path nicely: A -> B -> C -> A
			cyclePath := ""
			for i, node := range cycle {
				if i > 0 {
					cyclePath += " -> "
				}
				cyclePath += node
			}
			return fmt.Errorf("%w: %s", ErrRecursiveType, cyclePath)
		}
	}

	return nil
}

// detectCycleInCUE recursively checks for cycles in type references using CUE values
func detectCycleInCUE(defName string, defValue, defsValue cue.Value, visited, path map[string]bool, depth int) []string {
	// Depth protection
	if depth > maxCycleDepth {
		return []string{fmt.Sprintf("<max-depth-%d-exceeded>", maxCycleDepth), defName}
	}

	// Check if we're in a cycle
	if path[defName] {
		return []string{defName}
	}
	if visited[defName] {
		return nil
	}

	visited[defName] = true
	path[defName] = true
	defer delete(path, defName)

	// Collect all refs from this def
	refLocs := collectRefsFromCUE(defValue)

	// Check each ref for cycles
	for _, refLoc := range refLocs {
		// Look up the referenced def
		refValue := defsValue.LookupPath(cue.ParsePath(refLoc.ref))
		if refValue.Err() != nil {
			// Ref not found - this will be caught by other validation
			continue
		}

		if cycle := detectCycleInCUE(refLoc.ref, refValue, defsValue, visited, path, depth+1); cycle != nil {
			return append([]string{defName}, cycle...)
		}
	}

	return nil
}

// refLocation tracks where a reference was found for better error messages
type refLocation struct {
	ref  string // The referenced type name
	path string // Human-readable path where this ref was found
}

// collectRefsFromCUE collects all type references from a CUE def value with location context
func collectRefsFromCUE(defValue cue.Value) []refLocation {
	return collectRefsWithPath(defValue, "")
}

// collectRefsWithPath is the internal implementation that tracks the path
func collectRefsWithPath(defValue cue.Value, pathPrefix string) []refLocation {
	var refs []refLocation

	// Check if this def itself is a ref
	typeValue := defValue.LookupPath(cue.ParsePath("type"))
	if typeValue.Err() == nil {
		typeStr, err := typeValue.String()
		if err == nil && typeStr == "ref" {
			// This is a ref type, get the ref field
			refValue := defValue.LookupPath(cue.ParsePath("ref"))
			if refValue.Err() == nil {
				if refStr, err := refValue.String(); err == nil {
					location := "type reference"
					if pathPrefix != "" {
						location = pathPrefix
					}
					refs = append(refs, refLocation{ref: refStr, path: location})
				}
			}
		}
	}

	// Check children for refs
	childrenValue := defValue.LookupPath(cue.ParsePath("children"))
	if childrenValue.Err() == nil {
		// Children is a list
		iter, err := childrenValue.List()
		if err == nil {
			idx := 0
			for iter.Next() {
				child := iter.Value()

				// Get the child's name for better error messages
				childName := ""
				nameValue := child.LookupPath(cue.ParsePath("name"))
				if nameValue.Err() == nil {
					if name, err := nameValue.String(); err == nil {
						childName = name
					}
				}

				// Each child has a "def" field
				childDef := child.LookupPath(cue.ParsePath("def"))
				if childDef.Err() == nil {
					// Build path context
					childPath := fmt.Sprintf("field '%s'", childName)
					if pathPrefix != "" {
						childPath = pathPrefix + " -> " + childPath
					}

					// Recursively collect refs from the child def
					refs = append(refs, collectRefsWithPath(childDef, childPath)...)
				}
				idx++
			}
		}
	}

	return refs
}

// checkRefsWithCUE validates that all type references point to valid top-level defs
func checkRefsWithCUE(schemaValue cue.Value) error {
	// Get the defs field
	defsValue := schemaValue.LookupPath(cue.ParsePath("defs"))
	if defsValue.Err() != nil {
		return fmt.Errorf("failed to lookup defs: %w", defsValue.Err())
	}

	// Build a set of valid def names
	validDefs := make(map[string]bool)
	iter, err := defsValue.Fields(cue.Definitions(true))
	if err != nil {
		return fmt.Errorf("failed to iterate defs: %w", err)
	}
	for iter.Next() {
		validDefs[iter.Label()] = true
	}

	// Check each def's refs
	iter, err = defsValue.Fields(cue.Definitions(true))
	if err != nil {
		return fmt.Errorf("failed to iterate defs: %w", err)
	}
	for iter.Next() {
		defName := iter.Label()
		defValue := iter.Value()

		// Collect all refs from this def with location context
		refLocs := collectRefsFromCUE(defValue)

		// Verify each ref points to a valid def
		for _, refLoc := range refLocs {
			if !validDefs[refLoc.ref] {
				return fmt.Errorf("def '%s' has invalid reference to '%s' (at %s) - referenced type is not defined in schema defs",
					defName, refLoc.ref, refLoc.path)
			}
		}
	}

	return nil
}
