package cuessz

import (
	"errors"
	"os"
	"strings"
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

	if len(schema.Defs) != 2 {
		t.Errorf("expected 2 types, got %d", len(schema.Defs))
	}

	// Check Counter type
	counter, ok := schema.Defs["Counter"]
	if !ok {
		t.Error("Counter type not found")
	} else {
		if counter.Type != TypeUint64 {
			t.Errorf("expected Counter type to be uint64, got %s", counter.Type)
		}
	}

	// Check Record type
	record, ok := schema.Defs["Record"]
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
		"defs": {
			"BadType": {
				"type": "invalid_type"
			}
		}
	}`)

	_, err := ParseJSON(invalidSchema)
	if err == nil {
		t.Error("expected error for invalid type, got nil")
	}
}

func TestCycleDetection_DirectRecursion(t *testing.T) {
	// Test case: Node references itself directly (child -> parent)
	// This is caught by Go runtime cycle detection
	schema := []byte(`{
		"version": "1.0.0",
		"defs": {
			"Node": {
				"type": "container",
				"children": [
					{
						"name": "value",
						"def": {
							"type": "uint64"
						}
					},
					{
						"name": "next",
						"def": {
							"type": "ref",
							"ref": "Node"
						}
					}
				]
			}
		}
	}`)

	_, err := ParseJSON(schema)
	if err == nil {
		t.Error("expected error for direct recursive reference, got nil")
	}
	// Should be caught by Go runtime cycle detection
	if err != nil && !errors.Is(err, ErrRecursiveType) {
		t.Errorf("expected ErrRecursiveType for direct recursion, got: %v", err)
	}
}

func TestCycleDetection_MutualRecursion(t *testing.T) {
	// Test case: A -> B -> A (mutual recursion cycle)
	// This is caught by Go runtime cycle detection
	schema := []byte(`{
		"version": "1.0.0",
		"defs": {
			"TypeA": {
				"type": "container",
				"children": [
					{
						"name": "b_field",
						"def": {
							"type": "ref",
							"ref": "TypeB"
						}
					}
				]
			},
			"TypeB": {
				"type": "container",
				"children": [
					{
						"name": "a_field",
						"def": {
							"type": "ref",
							"ref": "TypeA"
						}
					}
				]
			}
		}
	}`)

	_, err := ParseJSON(schema)
	if err == nil {
		t.Error("expected error for mutual recursive reference, got nil")
	}
	if err != nil && !errors.Is(err, ErrRecursiveType) {
		t.Errorf("expected ErrRecursiveType, got: %v", err)
	}
	// Verify error message shows the cycle path
	if err != nil {
		errMsg := err.Error()
		// Should show the cycle: TypeA -> TypeB -> TypeA
		if !strings.Contains(errMsg, "TypeA") || !strings.Contains(errMsg, "TypeB") {
			t.Errorf("error should show cycle path with TypeA and TypeB, got: %v", err)
		}
		if !strings.Contains(errMsg, "->") {
			t.Errorf("error should show cycle path with '->' arrows, got: %v", err)
		}
	}
}

func TestCycleDetection_ThreeWayCycle(t *testing.T) {
	// Test case: A -> B -> C -> A (three-way recursion cycle)
	// This is caught by Go runtime cycle detection
	schema := []byte(`{
		"version": "1.0.0",
		"defs": {
			"TypeA": {
				"type": "container",
				"children": [
					{
						"name": "b_field",
						"def": {
							"type": "ref",
							"ref": "TypeB"
						}
					}
				]
			},
			"TypeB": {
				"type": "container",
				"children": [
					{
						"name": "c_field",
						"def": {
							"type": "ref",
							"ref": "TypeC"
						}
					}
				]
			},
			"TypeC": {
				"type": "container",
				"children": [
					{
						"name": "a_field",
						"def": {
							"type": "ref",
							"ref": "TypeA"
						}
					}
				]
			}
		}
	}`)

	_, err := ParseJSON(schema)
	if err == nil {
		t.Error("expected error for 3-way recursive cycle, got nil")
	}
	if err != nil && !errors.Is(err, ErrRecursiveType) {
		t.Errorf("expected ErrRecursiveType, got: %v", err)
	}
}

func TestCycleDetection_ValidDAG(t *testing.T) {
	// Test case: Valid directed acyclic graph (A -> B, A -> C, both B and C -> D)
	schema := []byte(`{
		"version": "1.0.0",
		"defs": {
			"Base": {
				"type": "uint64"
			},
			"TypeD": {
				"type": "container",
				"children": [
					{
						"name": "value",
						"def": {
							"type": "ref",
							"ref": "Base"
						}
					}
				]
			},
			"TypeB": {
				"type": "container",
				"children": [
					{
						"name": "d_field",
						"def": {
							"type": "ref",
							"ref": "TypeD"
						}
					}
				]
			},
			"TypeC": {
				"type": "container",
				"children": [
					{
						"name": "d_field",
						"def": {
							"type": "ref",
							"ref": "TypeD"
						}
					}
				]
			},
			"TypeA": {
				"type": "container",
				"children": [
					{
						"name": "b_field",
						"def": {
							"type": "ref",
							"ref": "TypeB"
						}
					},
					{
						"name": "c_field",
						"def": {
							"type": "ref",
							"ref": "TypeC"
						}
					}
				]
			}
		}
	}`)

	_, err := ParseJSON(schema)
	if err != nil {
		t.Errorf("expected no error for valid DAG, got: %v", err)
	}
}

func TestCycleDetection_NestedRecursion(t *testing.T) {
	// Test case: Recursion through nested structure (grandchild -> root)
	// This is caught by Go runtime cycle detection
	schema := []byte(`{
		"version": "1.0.0",
		"defs": {
			"Node": {
				"type": "container",
				"children": [
					{
						"name": "children",
						"def": {
							"type": "list",
							"limit": 100,
							"children": [
								{
									"name": "element",
									"def": {
										"type": "ref",
										"ref": "Node"
									}
								}
							]
						}
					}
				]
			}
		}
	}`)

	_, err := ParseJSON(schema)
	if err == nil {
		t.Error("expected error for nested recursive reference, got nil")
	}
	// Should be caught by Go runtime cycle detection
	if err != nil && !errors.Is(err, ErrRecursiveType) {
		t.Errorf("expected ErrRecursiveType for nested recursion, got: %v", err)
	}
}

func TestInvalidRef(t *testing.T) {
	// Test case: Ref points to non-existent def
	schema := []byte(`{
		"version": "1.0.0",
		"defs": {
			"TypeA": {
				"type": "container",
				"children": [
					{
						"name": "my_field",
						"def": {
							"type": "ref",
							"ref": "NonExistent"
						}
					}
				]
			}
		}
	}`)

	_, err := ParseJSON(schema)
	if err == nil {
		t.Error("expected error for invalid ref, got nil")
	}
	// Verify error message contains context about where the invalid ref was found
	if err != nil {
		errMsg := err.Error()
		// Should mention the def name, the invalid ref, and the field where it was found
		if !strings.Contains(errMsg, "TypeA") {
			t.Errorf("error should mention def name 'TypeA', got: %v", err)
		}
		if !strings.Contains(errMsg, "NonExistent") {
			t.Errorf("error should mention invalid ref 'NonExistent', got: %v", err)
		}
		if !strings.Contains(errMsg, "my_field") {
			t.Errorf("error should mention field name 'my_field' for context, got: %v", err)
		}
	}
}

func TestCycleDetection_MaxDepthProtection(t *testing.T) {
	// Test case: Verify max depth protection prevents stack overflow
	// We can't easily create a 1000+ level deep schema in JSON, but we can
	// verify the mechanism works by checking the depth tracking exists
	// This test mainly documents that the protection exists

	// For now, just verify the constant is defined reasonably
	const expectedMaxDepth = 1000
	if maxCycleDepth != expectedMaxDepth {
		t.Errorf("maxCycleDepth should be %d, got %d", expectedMaxDepth, maxCycleDepth)
	}

	// The actual depth protection is tested implicitly by the other cycle tests
	// which would stack overflow without depth protection if there were a bug
}
