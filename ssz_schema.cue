package cuessz

// SSZ Type System Definition
// This schema defines the structure for declaring SSZ types that can be used
// for code generation across multiple languages.

// TypeDefinition is a single structure that represents all possible SSZ types.
// The 'kind' field determines which other fields are populated.
// This design avoids union types which don't translate well to Go.
#TypeDefinition: {
	// Discriminator field - determines which fields below are relevant
	kind: "basic" | "container" | "vector" | "list" | "union" | "bitvector" | "bitlist"

	// Basic type field (populated when kind == "basic")
	type?: "bool" | "uint8" | "uint16" | "uint32" | "uint64" | "uint128" | "uint256"

	// Container fields (populated when kind == "container")
	fields?: [...#Field]

	// Vector and List element type (populated when kind == "vector" or "list")
	elem?: #TypeDefinition

	// Vector length (populated when kind == "vector")
	length?: uint & >0

	// List and Bitlist max length (populated when kind == "list" or "bitlist")
	maxLength?: uint & >0

	// Union options (populated when kind == "union")
	options?: [...#TypeDefinition]

	// Optional description for documentation
	description?: string

	// Language-specific extensions
	extensions?: #TypeExtensions

	// Progressive container support (EIP-7495)
	// Indicates if this is a stable container that supports future extensions
	stable?: bool

	// Active fields pattern for progressive containers (EIP-7495)
	// Specifies which merkle tree positions contain actual fields (0 = skip, 1 = field present)
	// - Length can be up to 256
	// - Count of 1s must equal number of fields in the container
	// - Last element must be 1 if present (cannot end in 0)
	// Example: [1, 0, 1] means field 0 at merkle index 0, field 1 at merkle index 2
	active_fields?: [...0 | 1]
}

// Field represents a named field in a container
#Field: {
	name: string
	type: #TypeDefinition
	// Optional description for documentation
	description?: string
	// Optional field (for progressive/stable containers per EIP-7495)
	optional?: bool
	// Language-specific extensions
	extensions?: #TypeExtensions
}

// Schema-level Go extensions for package configuration
#GoSchemaExtension: {
	// Package name for generated Go code
	package?: string
	// Import path for the package
	importPath?: string
	// Import alias for external packages
	alias?: string
}

// Type-level Go extensions for individual types and fields
#GoTypeExtension: {
	// Custom type name (if different from schema name)
	name?: string
	// Import package for external types (used with name)
	import?: string
	// Additional struct tags
	tags?: {[string]: string}
}

// Schema-level extensions for language-specific code generation
#SchemaExtensions: {
	go?: #GoSchemaExtension
}

// Type-level extensions for language-specific code generation
#TypeExtensions: {
	go?: #GoTypeExtension
}

// Schema represents a collection of named type definitions
#Schema: {
	// Schema version for compatibility tracking
	version: string | *"1.0.0"

	// Named type definitions
	types: {[string]: #TypeDefinition}

	// Optional metadata
	metadata?: {
		namespace?:   string
		description?: string
		authors?: [...string]
	}

	// Language-specific extensions for code generation
	extensions?: #SchemaExtensions
}
