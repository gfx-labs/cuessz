package examples

import "github.com/gfx-labs/cuessz"

// Example demonstrating SSZ Union types

unionTypes: cuessz.#Schema & {
	version: "1.0.0"
	metadata: {
		namespace:   "example.union"
		description: "Example of SSZ union types"
	}

	types: {
		// Basic types
		Amount: {
			kind: "basic"
			type: "uint64"
		}

		Hash: {
			kind:   "vector"
			length: 32
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		// Different transaction types
		TransferTransaction: {
			kind: "container"
			fields: [
				{
					name: "from"
					type: Hash
				},
				{
					name: "to"
					type: Hash
				},
				{
					name: "amount"
					type: Amount
				},
			]
		}

		CreateContractTransaction: {
			kind: "container"
			fields: [
				{
					name: "from"
					type: Hash
				},
				{
					name: "code"
					type: {
						kind:      "list"
						maxLength: 24576
						elem: {
							kind: "basic"
							type: "uint8"
						}
					}
				},
				{
					name: "initial_value"
					type: Amount
				},
			]
		}

		CallContractTransaction: {
			kind: "container"
			fields: [
				{
					name: "from"
					type: Hash
				},
				{
					name: "contract"
					type: Hash
				},
				{
					name: "method_id"
					type: {
						kind: "basic"
						type: "uint32"
					}
				},
				{
					name: "params"
					type: {
						kind:      "list"
						maxLength: 1024
						elem: {
							kind: "basic"
							type: "uint8"
						}
					}
				},
			]
		}

		// Union type - a transaction can be one of several types
		Transaction: {
			kind: "union"
			description: "A transaction can be a transfer, contract creation, or contract call"
			options: [
				TransferTransaction,
				CreateContractTransaction,
				CallContractTransaction,
			]
			// Note: Selector type (uint8 for max 256 variants) would be handled
			// by code generators, not defined in the schema
		}

		// You can use the union in other types
		Block: {
			kind: "container"
			fields: [
				{
					name: "number"
					type: {
						kind: "basic"
						type: "uint64"
					}
				},
				{
					name: "parent_hash"
					type: Hash
				},
				{
					name: "transactions"
					type: {
						kind:      "list"
						maxLength: 1000
						// Type-safe reference to the union type!
						elem: Transaction
					}
				},
			]
		}
	}
}
