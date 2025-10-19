package cuessz

import (
	"os"
	"testing"
)

func TestParseJSON(t *testing.T) {
	// Read test schema
	data, err := os.ReadFile("/tmp/test_schema.json")
	if err != nil {
		t.Fatalf("failed to read test schema: %v", err)
	}

	// Parse and validate
	schema, err := ParseJSON(data)
	if err != nil {
		t.Fatalf("ParseJSON failed: %v", err)
	}

	// Verify schema loaded correctly
	if schema.Version != "1.0.0" {
		t.Errorf("expected version 1.0.0, got %s", schema.Version)
	}

	if len(schema.Types) != 2 {
		t.Errorf("expected 2 types, got %d", len(schema.Types))
	}

	// Check Counter type
	counter, ok := schema.Types["Counter"]
	if !ok {
		t.Error("Counter type not found")
	} else {
		if counter.Type != TypeUint64 {
			t.Errorf("expected Counter type to be uint64, got %s", counter.Type)
		}
	}

	// Check Record type
	record, ok := schema.Types["Record"]
	if !ok {
		t.Error("Record type not found")
	} else {
		if record.Type != TypeContainer {
			t.Errorf("expected Record type to be container, got %s", record.Type)
		}
		if len(record.Children) != 1 {
			t.Errorf("expected 1 child, got %d", len(record.Children))
		}
	}
}

func TestParseInvalidJSON(t *testing.T) {
	// Test invalid schema
	invalidSchema := []byte(`{
		"version": "1.0.0",
		"types": {
			"BadType": {
				"name": "BadType",
				"type": "invalid_type"
			}
		}
	}`)

	_, err := ParseJSON(invalidSchema)
	if err == nil {
		t.Error("expected error for invalid type, got nil")
	}
}
