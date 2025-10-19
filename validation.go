package cuessz

import (
	_ "embed"
	"encoding/json"
	"fmt"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
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
		return nil, fmt.Errorf("schema validation failed: %w", err)
	}

	// Parse into Go struct
	var schema Schema
	if err := json.Unmarshal(data, &schema); err != nil {
		return nil, fmt.Errorf("failed to unmarshal into Go struct: %w", err)
	}

	// Also run Go-side validation for additional checks
	if err := schema.Validate(); err != nil {
		return nil, fmt.Errorf("Go validation failed: %w", err)
	}

	return &schema, nil
}
