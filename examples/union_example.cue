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
			type: "uint64"
		}

		Hash: {
			type: "vector"
			size: 32
			children: [
				{
					name: "element"
					type: {
						type: "uint8"
					}
				},
			]
		}

		// Different transaction types
		TransferTransaction: {
			type: "container"
			children: [
				{
					name: "from"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
				{
					name: "to"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
				{
					name: "amount"
					type: {
						type: "ref"
						ref:  "Amount"
					}
				},
			]
		}

		CreateContractTransaction: {
			type: "container"
			children: [
				{
					name: "from"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
				{
					name: "code"
					type: {
						type:  "list"
						limit: 24576
						children: [
							{
								name: "element"
								type: {
									type: "uint8"
								}
							},
						]
					}
				},
				{
					name: "initial_value"
					type: {
						type: "ref"
						ref:  "Amount"
					}
				},
			]
		}

		CallContractTransaction: {
			type: "container"
			children: [
				{
					name: "from"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
				{
					name: "contract"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
				{
					name: "method_id"
					type: {
						type: "uint32"
					}
				},
				{
					name: "params"
					type: {
						type:  "list"
						limit: 1024
						children: [
							{
								name: "element"
								type: {
									type: "uint8"
								}
							},
						]
					}
				},
			]
		}

		// Union type - a transaction can be one of several types
		Transaction: {
			type: "union"
			children: [
				{
					name: "TransferTransaction"
					type: {
						type: "ref"
						ref:  "TransferTransaction"
					}
				},
				{
					name: "CreateContractTransaction"
					type: {
						type: "ref"
						ref:  "CreateContractTransaction"
					}
				},
				{
					name: "CallContractTransaction"
					type: {
						type: "ref"
						ref:  "CallContractTransaction"
					}
				},
			]
		}

		// You can use the union in other types
		Block: {
			type: "container"
			children: [
				{
					name: "number"
					type: {
						type: "uint64"
					}
				},
				{
					name: "parent_hash"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
				{
					name: "transactions"
					type: {
						type:  "list"
						limit: 1000
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Transaction"
								}
							},
						]
					}
				},
			]
		}
	}
}
