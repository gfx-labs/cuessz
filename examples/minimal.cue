package examples

import "github.com/gfx-labs/cuessz"

// Minimal complete example - the simplest possible SSZ schema

minimal: cuessz.#Schema & {
	version: "1.0.0"

	types: {
		// A simple unsigned integer type
		Counter: {
			type: "uint64"
		}

		// A simple container with one field
		Record: {
			type: "container"
			children: [
				{
					name: "count"
					type: {
						type: "ref"
						ref:  "Counter"
					}
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
//       "type": "uint64"
//     },
//     "Record": {
//       "type": "container",
//       "children": [
//         {
//           "name": "count",
//           "type": {
//             "type": "ref",
//             "ref": "Counter"
//           }
//         }
//       ]
//     }
//   }
// }
