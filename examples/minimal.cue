package examples

import "github.com/gfx-labs/cuessz"

// Minimal complete example - the simplest possible SSZ schema

minimal: cuessz.#Schema & {
	version: "1.0.0"

	types: {
		// A simple unsigned integer type
		Counter: {
			kind: "basic"
			type: "uint64"
		}

		// A simple container with one field
		Record: {
			kind: "container"
			fields: [
				{
					name: "count"
					type: Counter
				},
			]
		}
	}
}

// When exported to JSON, this becomes:
// {
//   "version": "1.0.0",
//   "types": {
//     "Counter": {
//       "kind": "basic",
//       "type": "uint64"
//     },
//     "Record": {
//       "kind": "container",
//       "fields": [
//         {
//           "name": "count",
//           "type": {
//             "kind": "basic",
//             "type": "uint64"
//           }
//         }
//       ]
//     }
//   }
// }
