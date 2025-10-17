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

	types: {
		// UserProfile: Simple stable container that can be extended in future versions
		// This demonstrates the basic stable container feature
		UserProfile: {
			kind:   "container"
			stable: true
			description: "User profile that can be extended with new optional fields"
			fields: [
				{
					name:        "id"
					type:        {kind: "basic", type: "uint64"}
					description: "Required: User ID"
				},
				{
					name:        "username"
					type:        {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					description: "Required: Username hash"
				},
				{
					name:        "email"
					type:        {kind: "vector", length: 64, elem: {kind: "basic", type: "uint8"}}
					optional:    true
					description: "Optional: Email hash (added in v2)"
				},
				{
					name:        "verified"
					type:        {kind: "basic", type: "bool"}
					optional:    true
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
			kind:          "container"
			stable:        true
			active_fields: [1, 0, 1]
			description:   "Message with reserved merkle position for future expansion"
			fields: [
				{
					name:        "text"
					type:        {kind: "vector", length: 256, elem: {kind: "basic", type: "uint8"}}
					description: "Message text (at merkle position 0)"
				},
				{
					name:        "timestamp"
					type:        {kind: "basic", type: "uint64"}
					description: "Timestamp (at merkle position 2)"
				},
			]
		}

		// ExtendedMessage: Evolution of SimpleMessage using the reserved position
		// active_fields: [1, 1, 1] now uses position 1 that was reserved
		ExtendedMessage: {
			kind:          "container"
			stable:        true
			active_fields: [1, 1, 1]
			description:   "Extended message now using the reserved merkle position"
			fields: [
				{
					name:        "text"
					type:        {kind: "vector", length: 256, elem: {kind: "basic", type: "uint8"}}
					description: "Message text (at merkle position 0)"
				},
				{
					name:        "priority"
					type:        {kind: "basic", type: "uint8"}
					description: "Priority level (at merkle position 1 - was reserved)"
				},
				{
					name:        "timestamp"
					type:        {kind: "basic", type: "uint64"}
					description: "Timestamp (at merkle position 2)"
				},
			]
		}

		// Config: Simple 3-field stable container
		Config: {
			kind:        "container"
			stable:      true
			description: "Configuration with all optional fields"
			fields: [
				{
					name:        "max_size"
					type:        {kind: "basic", type: "uint64"}
					optional:    true
					description: "Maximum size limit"
				},
				{
					name:        "timeout"
					type:        {kind: "basic", type: "uint64"}
					optional:    true
					description: "Timeout in seconds"
				},
				{
					name:        "enabled"
					type:        {kind: "basic", type: "bool"}
					optional:    true
					description: "Whether feature is enabled"
				},
			]
		}

		// Transaction: Demonstrates sparse field layout
		// active_fields: [1, 0, 0, 1] means fields at positions 0 and 3
		// This is useful when you know you'll need positions 1 and 2 later
		Transaction: {
			kind:          "container"
			stable:        true
			active_fields: [1, 0, 0, 1]
			description:   "Transaction with reserved positions for future fields"
			fields: [
				{
					name:        "from"
					type:        {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					description: "Sender address (merkle position 0)"
				},
				{
					name:        "amount"
					type:        {kind: "basic", type: "uint64"}
					description: "Amount (merkle position 3)"
				},
			]
		}
	}
}
