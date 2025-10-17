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
			kind: "basic"
			type: "uint64"
		}

		// Fixed-size byte array (32 bytes)
		Hash: {
			kind:   "vector"
			length: 32
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		// Simple container (like a struct)
		Person: {
			kind:        "container"
			description: "A person with name and age"
			fields: [
				{
					name: "name"
					type: {
						kind:      "list"
						maxLength: 64
						elem: {
							kind: "basic"
							type: "uint8"
						}
					}
					description: "UTF-8 encoded name (max 64 bytes)"
				},
				{
					name: "age"
					type: {
						kind: "basic"
						type: "uint8"
					}
				},
				{
					name: "active"
					type: {
						kind: "basic"
						type: "bool"
					}
				},
			]
		}

		// Container with references to other types (type-safe!)
		Transaction: {
			kind:        "container"
			description: "A simple transaction"
			fields: [
				{
					name:        "from"
					type:        Hash
					description: "Sender address hash"
				},
				{
					name:        "to"
					type:        Hash
					description: "Recipient address hash"
				},
				{
					name:        "amount"
					type:        Amount
					description: "Transfer amount"
				},
				{
					name: "nonce"
					type: {
						kind: "basic"
						type: "uint64"
					}
				},
			]
		}

		// Variable-length list of transactions
		TransactionList: {
			kind:        "list"
			maxLength:   100
			description: "List of up to 100 transactions"
			elem: Transaction
		}

		// Fixed-length vector of hashes
		MerkleProof: {
			kind:        "vector"
			length:      8
			description: "Merkle proof with 8 hashes"
			elem: Hash
		}

		// Bitlist example
		Participants: {
			kind:        "bitlist"
			maxLength:   256
			description: "Bitlist of up to 256 participants"
		}

		// Bitvector example
		Flags: {
			kind:        "bitvector"
			length:      8
			description: "8 boolean flags"
		}

		// Complex container combining multiple types
		Block: {
			kind:        "container"
			description: "A block containing transactions"
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
					type: TransactionList
				},
				{
					name: "merkle_proof"
					type: MerkleProof
				},
				{
					name: "participation"
					type: Participants
				},
			]
		}
	}
}
