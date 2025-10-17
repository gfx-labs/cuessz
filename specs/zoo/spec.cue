package zoo

import "github.com/gfx-labs/cuessz"

// Zoo from https://github.com/ethereum/py-ssz/blob/v0.5.2/ssz/examples/zoo.py
Zoo: cuessz.#Schema & {
	version: "1.0.0"
	metadata: {
		namespace:   "examples.zoo"
		description: "Example SSZ types demonstrating various SSZ features"
		authors: ["gfx labs"]
	}

	types: {
		// Basic type aliases for clarity
		bytes32: {
			kind:   "vector"
			length: 32
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		bytes48: {
			kind:   "vector"
			length: 48
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		bytes96: {
			kind:   "vector"
			length: 96
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		// ClockInRecords tracks when animals check in at the zoo
		ClockInRecords: {
			kind: "container"
			fields: [
				{
					name: "epoch"
					type: {kind: "basic", type: "uint64"}
					description: "Timestamp epoch of clock-in"
				},
				{
					name:        "bio_id_scan"
					type:        bytes32
					description: "Biometric ID scan hash"
				},
				{
					name: "poo_log_bits"
					type: {
						kind:      "bitlist"
						maxLength: 32
					}
					description: "Log of bathroom activities (bitlist)"
				},
				{
					name: "wash_log_bits"
					type: {
						kind:   "bitvector"
						length: 32
					}
					description: "Log of hand-washing activities (bitvector)"
				},
				{
					name:        "signature"
					type:        bytes96
					description: "Signature attesting to the record"
				},
			]
		}

		// Animal represents a zoo animal with various attributes
		Animal: {
			kind: "container"
			fields: [
				{
					name:        "id_hash"
					type:        bytes32
					description: "Unique identifier hash for the animal"
				},
				{
					name:        "public_key"
					type:        bytes48
					description: "Animal's public key"
				},
				{
					name: "clock_in_records"
					type: {
						kind:      "list"
						maxLength: 4294967296 // 2^32
						elem:      ClockInRecords
					}
					description: "List of all clock-in records"
				},
				{
					name: "vaccinated"
					type: {kind: "basic", type: "bool"}
					description: "Vaccination status"
				},
			]
		}

		// Zoo contains a fixed number of animals
		Zoo: {
			kind: "container"
			fields: [
				{
					name: "animals"
					type: {
						kind:   "vector"
						length: 3
						elem:   Animal
					}
					description: "Fixed vector of 3 animals"
				},
			]
		}
	}
}
