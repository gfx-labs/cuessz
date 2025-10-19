package cuessz

import ( "list"

	// SSZ Type System Definition
	// This schema defines the structure for declaring SSZ types that can be used
	// for code generation across multiple languages.
)

// Type represents an SSZ type definition
#Type: {
	type: "uint8" | "uint16" | "uint32" | "uint64" | "uint128" | "uint256" | "boolean" |
		"container" | "progressive_container" | "vector" | "list" |
		"bitvector" | "bitlist" | "union" | "ref"

	// Optional documentation for this type
	description?: string

	// this is the size for vectors and bitvectors
	if list.Contains(["vector", "bitvector"], type) {
		size: uint & >0
	}

	// this is the max length for lists and bitlists
	if list.Contains(["list", "bitlist"], type) {
		limit: uint & >0
	}

	// container, progressive_container, vector, list, union have children
	if list.Contains(["container", "progressive_container", "union"], type) {
		children: [...#Field]
	} // NOTE: it would be great to have cue if-else semantics here...

	// but for vector and list, it contains children, and it must be must be exactly length 1
	if list.Contains(["vector", "list"], type) {
		children: [...#Field] & list.MinItems(1) & list.MaxItems(1)
	}

	// ref types must provide a string ref
	if type == "ref" {
		ref: string
	}

	if type == "progressive_container" {
		// Bitset indicating which merkle tree positions contain actual fields (0 = skip, 1 = field present)
		// - Length can be up to 256
		// - Count of 1s must equal number of children
		// - Last element must be 1 if present (cannot end in 0)
		active_fields: [...int]
	}
}

// Field represents a named field within a container (used in children arrays)
#Field: {
	name:         string
	type:         #Type
	description?: string // Optional documentation for this field
}

// Schema represents a collection of named type definitions
#Schema: {
	// Schema version for compatibility tracking
	version: string | *"1.0.0"

	// type definitions ( the actuall busuness)
	types: {[string]: #Type}

	// Optional metadata
	metadata?: {
		namespace?:   string
		description?: string
		authors?: [...string]
	}

	// Validate all type references exist
	// This ensures compile-time type safety for refs
	for typeName, t in types {
		// Check top-level type refs
		if t.type == "ref" {
			if t.ref != _|_ {
				// Require the referenced type to exist
				types: "\(t.ref)": _
			}
		}

		// Check refs in children
		if t.children != _|_ {
			for i, child in t.children {
				if child.type.type == "ref" {
					if child.type.ref != _|_ {
						// Require the referenced type to exist
						types: "\(child.type.ref)": _
					}
				}

				// Recursively check children of children (for nested containers)
				if child.type.children != _|_ {
					for j, grandchild in child.type.children {
						if grandchild.type.type == "ref" {
							if grandchild.type.ref != _|_ {
								// Require the referenced type to exist
								types: "\(grandchild.type.ref)": _
							}
						}
					}
				}
			}
		}
	}

	// NOTE: Recursive reference checking (cycle detection) is implemented
	// in Go-level validation, as CUE cannot perform arbitrary-depth graph traversal
}
