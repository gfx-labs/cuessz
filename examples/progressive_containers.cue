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
		// Square shape with side and color
		Square: {
			kind:          "container"
			stable:        true
			active_fields: [1, 0, 1]  // Field at merkle index 0, skip 1, field at 2
			description:   "A square with side length and color"
			fields: [
				{
					name: "side"
					type: {kind: "basic", type: "uint16"}
				},
				{
					name: "color"
					type: {kind: "basic", type: "uint8"}
				},
			]
		}

		// Circle shape with radius and color
		Circle: {
			kind:          "container"
			stable:        true
			active_fields: [0, 1, 1]  // Skip 0, field at merkle index 1, field at 2
			description:   "A circle with radius and color"
			fields: [
				{
					name: "radius"
					type: {kind: "basic", type: "uint16"}
				},
				{
					name: "color"
					type: {kind: "basic", type: "uint8"}
				},
			]
		}

		// Basic stable container (V1 of execution payload header)
		ExecutionPayloadHeaderV1: {
			kind:   "container"
			stable: true
			active_fields: [
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  // All 15 V1 fields active
			]
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

		// Extended version with additional fields (V2)
		ExecutionPayloadHeaderV2: {
			kind:   "container"
			stable: true
			active_fields: [
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  // All 15 V1 fields
				1, 1,  // Plus 2 new V2 fields
			]
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
				// New fields in V2
				{
					name: "blob_gas_used"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "excess_blob_gas"
					type: {kind: "basic", type: "uint64"}
				},
			]
		}

		// Validator record V1 (pre-EIP-7251)
		ValidatorRecordV1: {
			kind:          "container"
			stable:        true
			active_fields: [1, 1, 1, 1, 1, 1, 1]  // All 7 original fields
			description:   "Validator record before EIP-7251"
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
			]
		}

		// Validator record V2 (with EIP-7251)
		ValidatorRecordV2: {
			kind:          "container"
			stable:        true
			active_fields: [1, 1, 1, 1, 1, 1, 1, 1]  // 7 original + 1 new field
			description:   "Validator record with EIP-7251: Increase the MAX_EFFECTIVE_BALANCE"
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
				{
					name:        "max_effective_balance"
					type:        {kind: "basic", type: "uint64"}
					description: "EIP-7251: Increase the MAX_EFFECTIVE_BALANCE"
				},
			]
		}
	}
}
