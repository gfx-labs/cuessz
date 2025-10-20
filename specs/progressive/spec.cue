package progressive

import "github.com/gfx-labs/cuessz"

// Progressive demonstrates EIP-7495 progressive/stable container features
// These are simple examples designed for testing and understanding the feature
Progressive: cuessz.#Schema & {
	version: "1.0.0"
	metadata: {
		namespace:   "examples.progressive"
		description: "Simple examples demonstrating EIP-7495 progressive containers"
		authors: ["gfx labs"]
	}

	defs: {
		// UserProfile: Simple stable container that can be extended in future versions
		// This demonstrates the basic stable container feature
		UserProfile: {
			type:        "progressive_container"
			active_fields: [1, 1, 1, 1]
			description: "User profile that can be extended with new optional fields"
			children: [
				{
					name: "id"
					def: {
						type: "uint64"
					}
					description: "Required: User ID"
				},
				{
					name: "username"
					def: {
						type: "vector"
						size: 32
						children: [
							{
								name: "element"
								def: {
									type: "uint8"
								}
							},
						]
					}
					description: "Required: Username hash"
				},
				{
					name: "email"
					def: {
						type: "vector"
						size: 64
						children: [
							{
								name: "element"
								def: {
									type: "uint8"
								}
							},
						]
					}
					description: "Optional: Email hash (added in v2)"
				},
				{
					name: "verified"
					def: {
						type: "boolean"
					}
					description: "Optional: Verification status (added in v2)"
				},
			]
		}

		// SimpleMessage: Demonstrates active_fields pattern
		// active_fields: [1, 0, 1] means:
		//   - Field 0 (text) is at merkle position 0
		//   - Merkle position 1 is reserved/skipped
		//   - Field 1 (timestamp) is at merkle position 2
		SimpleMessage: {
			type:          "progressive_container"
			active_fields: [1, 0, 1]
			description:   "Message with reserved merkle position for future expansion"
			children: [
				{
					name: "text"
					def: {
						type: "vector"
						size: 256
						children: [
							{
								name: "element"
								def: {
									type: "uint8"
								}
							},
						]
					}
					description: "Message text (at merkle position 0)"
				},
				{
					name: "timestamp"
					def: {
						type: "uint64"
					}
					description: "Timestamp (at merkle position 2)"
				},
			]
		}

		// ExtendedMessage: Evolution of SimpleMessage using the reserved position
		// active_fields: [1, 1, 1] now uses position 1 that was reserved
		ExtendedMessage: {
			type:          "progressive_container"
			active_fields: [1, 1, 1]
			description:   "Extended message now using the reserved merkle position"
			children: [
				{
					name: "text"
					def: {
						type: "vector"
						size: 256
						children: [
							{
								name: "element"
								def: {
									type: "uint8"
								}
							},
						]
					}
					description: "Message text (at merkle position 0)"
				},
				{
					name: "priority"
					def: {
						type: "uint8"
					}
					description: "Priority level (at merkle position 1 - was reserved)"
				},
				{
					name: "timestamp"
					def: {
						type: "uint64"
					}
					description: "Timestamp (at merkle position 2)"
				},
			]
		}

		// Config: Simple 3-field stable container
		Config: {
			type:          "progressive_container"
			active_fields: [1, 1, 1]
			description:   "Configuration with all optional fields"
			children: [
				{
					name: "max_size"
					def: {
						type: "uint64"
					}
					description: "Maximum size limit"
				},
				{
					name: "timeout"
					def: {
						type: "uint64"
					}
					description: "Timeout in seconds"
				},
				{
					name: "enabled"
					def: {
						type: "boolean"
					}
					description: "Whether feature is enabled"
				},
			]
		}

		// Transaction: Demonstrates sparse field layout
		// active_fields: [1, 0, 0, 1] means fields at positions 0 and 3
		// This is useful when you know you'll need positions 1 and 2 later
		Transaction: {
			type:          "progressive_container"
			active_fields: [1, 0, 0, 1]
			description:   "Transaction with reserved positions for future fields"
			children: [
				{
					name: "from"
					def: {
						type: "vector"
						size: 32
						children: [
							{
								name: "element"
								def: {
									type: "uint8"
								}
							},
						]
					}
					description: "Sender address (merkle position 0)"
				},
				{
					name: "amount"
					def: {
						type: "uint64"
					}
					description: "Amount (merkle position 3)"
				},
			]
		}
	}
}
