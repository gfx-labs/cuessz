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

		bytes48: {
			type: "vector"
			size: 48
			children: [
				{
					name: "element"
					type: {
						type: "uint8"
					}
				},
			]
		}

		bytes96: {
			type: "vector"
			size: 96
			children: [
				{
					name: "element"
					type: {
						type: "uint8"
					}
				},
			]
		}

		// ClockInRecords tracks when animals check in at the zoo
		ClockInRecords: {
			type: "container"
			children: [
				{
					name: "epoch"
					type: {
						type: "uint64"
					}
					description: "Timestamp epoch of clock-in"
				},
				{
					name: "bio_id_scan"
					type: {
						type: "ref"
						ref:  "bytes32"
					}
					description: "Biometric ID scan hash"
				},
				{
					name: "poo_log_bits"
					type: {
						type:  "bitlist"
						limit: 32
					}
					description: "Log of bathroom activities (bitlist)"
				},
				{
					name: "wash_log_bits"
					type: {
						type: "bitvector"
						size: 32
					}
					description: "Log of hand-washing activities (bitvector)"
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "bytes96"
					}
					description: "Signature attesting to the record"
				},
			]
		}

		// Animal represents a zoo animal with various attributes
		Animal: {
			type: "container"
			children: [
				{
					name: "id_hash"
					type: {
						type: "ref"
						ref:  "bytes32"
					}
					description: "Unique identifier hash for the animal"
				},
				{
					name: "public_key"
					type: {
						type: "ref"
						ref:  "bytes48"
					}
					description: "Animal's public key"
				},
				{
					name: "clock_in_records"
					type: {
						type:  "list"
						limit: 4294967296 // 2^32
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "ClockInRecords"
								}
							},
						]
					}
					description: "List of all clock-in records"
				},
				{
					name: "vaccinated"
					type: {
						type: "boolean"
					}
					description: "Vaccination status"
				},
			]
		}

		// Zoo contains a fixed number of animals
		Zoo: {
			type: "container"
			children: [
				{
					name: "animals"
					type: {
						type: "vector"
						size: 3
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Animal"
								}
							},
						]
					}
					description: "Fixed vector of 3 animals"
				},
			]
		}
	}
}
