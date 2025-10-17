package examples

import "github.com/gfx-labs/cuessz"

// Progressive Containers (EIP-7495) Example
// https://eips.ethereum.org/EIPS/eip-7495
//
// Progressive containers allow for forward-compatible schema evolution
// by supporting optional fields that can be added in future versions
// without breaking existing serializations.

progressiveExample: cuessz.#Schema & {
	version: "1.0.0"
	types: {
		// Basic stable container with optional fields
		ExecutionPayloadHeaderV1: {
			kind:   "container"
			stable: true  // This is a stable container
			fields: [
				{
					name: "parent_hash"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "fee_recipient"
					type: {
						kind:   "vector"
						length: 20
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "state_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "receipts_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "logs_bloom"
					type: {
						kind:   "vector"
						length: 256
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "prev_randao"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "block_number"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "gas_limit"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "gas_used"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "timestamp"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "extra_data"
					type: {
						kind:      "list"
						maxLength: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "base_fee_per_gas"
					type: {kind: "basic", type: "uint256"}
				},
				{
					name: "block_hash"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "transactions_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "withdrawals_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
			]
		}

		// Extended version with additional optional fields
		ExecutionPayloadHeaderV2: {
			kind:   "container"
			stable: true
			fields: [
				// All V1 fields...
				{
					name: "parent_hash"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "fee_recipient"
					type: {
						kind:   "vector"
						length: 20
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "state_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "receipts_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "logs_bloom"
					type: {
						kind:   "vector"
						length: 256
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "prev_randao"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "block_number"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "gas_limit"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "gas_used"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "timestamp"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "extra_data"
					type: {
						kind:      "list"
						maxLength: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "base_fee_per_gas"
					type: {kind: "basic", type: "uint256"}
				},
				{
					name: "block_hash"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "transactions_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "withdrawals_root"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				// New optional fields in V2
				{
					name:     "blob_gas_used"
					optional: true  // Optional field for forward compatibility
					type: {kind: "basic", type: "uint64"}
				},
				{
					name:     "excess_blob_gas"
					optional: true
					type: {kind: "basic", type: "uint64"}
				},
			]
		}

		// Simple example of a stable container
		ValidatorRecord: {
			kind:   "container"
			stable: true
			description: "Stable container that can be extended in future forks"
			fields: [
				{
					name: "pubkey"
					type: {
						kind:   "vector"
						length: 48
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "withdrawal_credentials"
					type: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				},
				{
					name: "effective_balance"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "slashed"
					type: {kind: "basic", type: "bool"}
				},
				{
					name: "activation_epoch"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "exit_epoch"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "withdrawable_epoch"
					type: {kind: "basic", type: "uint64"}
				},
				// Future optional fields can be added here
				{
					name:     "max_effective_balance"
					optional: true
					type: {kind: "basic", type: "uint64"}
					description: "EIP-7251: Increase the MAX_EFFECTIVE_BALANCE"
				},
			]
		}
	}
}
