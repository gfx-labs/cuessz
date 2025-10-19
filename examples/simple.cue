package examples

import "github.com/gfx-labs/cuessz"

// Simple example demonstrating basic SSZ type declarations

simpleTypes: cuessz.#Schema & {
	version: "1.0.0"
	metadata: {
		namespace:   "example.simple"
		description: "Simple SSZ types example"
	}

	types: {
		// Basic unsigned integer
		Amount: {
			type: "uint64"
		}

		// Fixed-size byte array (32 bytes)
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

		// Simple container (like a struct)
		Person: {
			type: "container"
			children: [
				{
					name: "name"
					type: {
						type:  "list"
						limit: 64
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
					name: "age"
					type: {
						type: "uint8"
					}
				},
				{
					name: "active"
					type: {
						type: "boolean"
					}
				},
			]
		}

		// Container with references to other types (type-safe!)
		Transaction: {
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
				{
					name: "nonce"
					type: {
						type: "uint64"
					}
				},
			]
		}

		// Variable-length list of transactions
		TransactionList: {
			type:  "list"
			limit: 100
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

		// Fixed-length vector of hashes
		MerkleProof: {
			type: "vector"
			size: 8
			children: [
				{
					name: "element"
					type: {
						type: "ref"
						ref:  "Hash"
					}
				},
			]
		}

		// Bitlist example
		Participants: {
			type:  "bitlist"
			limit: 256
		}

		// Bitvector example
		Flags: {
			type: "bitvector"
			size: 8
		}

		// Complex container combining multiple types
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
						type: "ref"
						ref:  "TransactionList"
					}
				},
				{
					name: "merkle_proof"
					type: {
						type: "ref"
						ref:  "MerkleProof"
					}
				},
				{
					name: "participation"
					type: {
						type: "ref"
						ref:  "Participants"
					}
				},
			]
		}
	}
}
