package examples

import "github.com/gfx-labs/cuessz"

// Example demonstrating Go-specific extensions for code generation

goExample: cuessz.#Schema & {
	version: "1.0.0"

	metadata: {
		namespace:   "example.go"
		description: "Example with Go extensions"
	}

	// Schema-level Go extensions
	extensions: {
		go: {
			package:    "types"
			importPath: "github.com/myorg/myproject/types"
		}
	}

	types: {
		// Basic type
		Slot: {
			kind: "basic"
			type: "uint64"
		}

		// Hash with Go-specific type name
		Hash: {
			kind:   "vector"
			length: 32
			elem: {
				kind: "basic"
				type: "uint8"
			}
			// Override the type name in Go
			extensions: {
				go: {
					name: "Hash32"
					tags: json: "hash"
				}
			}
		}

		// Container with Go extensions
		Block: {
			kind: "container"
			description: "A block in the chain"
			fields: [
				{
					name: "slot"
					type: Slot
					// Field-level Go extensions
					extensions: {
						go: {
							tags: {
								yaml: "slot"
							}
						}
					}
				},
				{
					name: "parent_hash"
					type: Hash
					extensions: {
						go: {
							tags: {
								yaml: "parentHash"
							}
						}
					}
				},
				{
					name: "state_root"
					type: Hash
					extensions: {
						go: {
							tags: {
								json: "state_root,omitempty"
								validate: "required"
							}
						}
					}
				},
			]
			// Container-level Go extensions
			extensions: {
				go: {
					name: "BeaconBlock"
				}
			}
		}

		// Custom type that maps to existing Go type
		Address: {
			kind:   "vector"
			length: 20
			elem: {
				kind: "basic"
				type: "uint8"
			}
			extensions: {
				go: {
					// Use an existing type from an external package
					name:   "Address"
					import: "github.com/ethereum/go-ethereum/common"
				}
			}
		}

		// Transaction using the custom Address type
		Transaction: {
			kind: "container"
			fields: [
				{
					name: "from"
					type: Address
				},
				{
					name: "to"
					type: Address
				},
				{
					name: "value"
					type: {
						kind: "basic"
						type: "uint64"
					}
					extensions: {
						go: {
							tags: {
								units: "wei"
							}
						}
					}
				},
			]
			extensions: {
				go: {
					// Add custom methods or interfaces
					tags: {
						implements: "Hashable,Signable"
					}
				}
			}
		}
	}
}

// Example output when generating Go code:
//
// package types
//
// import (
//     "github.com/ethereum/go-ethereum/common"
// )
//
// type Hash32 [32]byte
//
// type BeaconBlock struct {
//     Slot       uint64  `yaml:"slot"`
//     ParentHash Hash32  `yaml:"parentHash"`
//     StateRoot  Hash32  `validate:"required"`
// }
//
// type Transaction struct {
//     From  common.Address
//     To    common.Address
//     Value uint64         `units:"wei"`
// }
