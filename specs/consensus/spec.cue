package consensus

import "github.com/gfx-labs/cuessz"

BeaconChain: cuessz.#Schema & {
	metadata: {
		namespace:   "eth2.beacon"
		description: "Ethereum Beacon Chain SSZ types"
		authors: ["gfx labs"]
	}

	types: {
		// ===== Basic Types =====

		Root: {
			type:   "vector"
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

		Signature: {
			type:   "vector"
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

		BLSPubkey: {
			type:   "vector"
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

		Uint256: {
			type:   "vector"
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

		// ===== Core Types =====

		Checkpoint: {
			type: "container"
			children: [
				{
					name: "epoch"
					type: {type: "uint64"}
				},
				{
					name: "root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
			]
		}

		AttestationData: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "index"
					type: {type: "uint64"}
				},
				{
					name: "beacon_block_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "source"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "target"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
			]
		}

		Attestation: {
			type: "container"
			children: [
				{
					name: "aggregation_bits"
					type: {type: "bitlist", limit: 2048}
				},
				{
					name: "data"
					type: {
						type: "ref"
						ref:  "AttestationData"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		AggregateAndProof: {
			type: "container"
			children: [
				{
					name: "aggregator_index"
					type: {type: "uint64"}
				},
				{
					name: "aggregate"
					type: {
						type: "ref"
						ref:  "Attestation"
					}
				},
				{
					name: "selection_proof"
					type: {type: "vector", size: 96, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		SignedAggregateAndProof: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "AggregateAndProof"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		DepositData: {
			type: "container"
			children: [
				{
					name: "pubkey"
					type: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "withdrawal_credentials"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "amount"
					type: {type: "uint64"}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		Deposit: {
			type: "container"
			children: [
				{
					name: "proof"
					type: {
						type:   "vector"
						size: 33
						children: [
							{
								name: "element"
								type: {
									type:   "vector"
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
							},
						]
					}
				},
				{
					name: "data"
					type: {
						type: "ref"
						ref:  "DepositData"
					}
				},
			]
		}

		DepositMessage: {
			type: "container"
			children: [
				{
					name: "pubkey"
					type: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "withdrawal_credentials"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "amount"
					type: {type: "uint64"}
				},
			]
		}

		IndexedAttestation: {
			type: "container"
			children: [
				{
					name: "attesting_indices"
					type: {type: "list", limit: 2048, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "data"
					type: {
						type: "ref"
						ref:  "AttestationData"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		PendingAttestation: {
			type: "container"
			children: [
				{
					name: "aggregation_bits"
					type: {type: "bitlist", limit: 2048}
				},
				{
					name: "data"
					type: {
						type: "ref"
						ref:  "AttestationData"
					}
				},
				{
					name: "inclusion_delay"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
			]
		}

		Fork: {
			type: "container"
			children: [
				{
					name: "previous_version"
					type: {type: "vector", size: 4, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "current_version"
					type: {type: "vector", size: 4, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "epoch"
					type: {type: "uint64"}
				},
			]
		}

		Validator: {
			type: "container"
			children: [
				{
					name: "pubkey"
					type: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "withdrawal_credentials"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "effective_balance"
					type: {type: "uint64"}
				},
				{
					name: "slashed"
					type: {type: "boolean"}
				},
				{
					name: "activation_eligibility_epoch"
					type: {type: "uint64"}
				},
				{
					name: "activation_epoch"
					type: {type: "uint64"}
				},
				{
					name: "exit_epoch"
					type: {type: "uint64"}
				},
				{
					name: "withdrawable_epoch"
					type: {type: "uint64"}
				},
			]
		}

		VoluntaryExit: {
			type: "container"
			children: [
				{
					name: "epoch"
					type: {type: "uint64"}
				},
				{
					name: "validator_index"
					type: {type: "uint64"}
				},
			]
		}

		SignedVoluntaryExit: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "VoluntaryExit"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		HistoricalBatch: {
			type: "container"
			children: [
				{
					name: "block_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type:   "vector"
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
							},
						]
					}
				},
				{
					name: "state_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type:   "vector"
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
							},
						]
					}
				},
			]
		}

		Eth1Data: {
			type: "container"
			children: [
				{
					name: "deposit_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "deposit_count"
					type: {type: "uint64"}
				},
				{
					name: "block_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		SigningRoot: {
			type: "container"
			children: [
				{
					name: "object_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "domain"
					type: {type: "list", limit: 8, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		BeaconBlockHeader: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
				{
					name: "parent_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
			]
		}

		SignedBeaconBlockHeader: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		ProposerSlashing: {
			type: "container"
			children: [
				{
					name: "signed_header_1"
					type: {
						type: "ref"
						ref:  "SignedBeaconBlockHeader"
					}
				},
				{
					name: "signed_header_2"
					type: {
						type: "ref"
						ref:  "SignedBeaconBlockHeader"
					}
				},
			]
		}

		AttesterSlashing: {
			type: "container"
			children: [
				{
					name: "attestation_1"
					type: {
						type: "ref"
						ref:  "IndexedAttestation"
					}
				},
				{
					name: "attestation_2"
					type: {
						type: "ref"
						ref:  "IndexedAttestation"
					}
				},
			]
		}

		Transfer: {
			type: "container"
			children: [
				{
					name: "sender"
					type: {type: "uint64"}
				},
				{
					name: "recipient"
					type: {type: "uint64"}
				},
				{
					name: "amount"
					type: {type: "uint64"}
				},
				{
					name: "fee"
					type: {type: "uint64"}
				},
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "pubkey"
					type: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		ForkData: {
			type: "container"
			children: [
				{
					name: "current_version"
					type: {type: "vector", size: 4, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "genesis_validators_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
			]
		}

		SigningData: {
			type: "container"
			children: [
				{
					name: "object_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "domain"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		Eth1Block: {
			type: "container"
			children: [
				{
					name: "timestamp"
					type: {type: "uint64"}
				},
				{
					name: "deposit_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "deposit_count"
					type: {type: "uint64"}
				},
			]
		}

		PowBlock: {
			type: "container"
			children: [
				{
					name: "block_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "parent_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "total_difficulty"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		// ===== Phase 0 Types =====

		BeaconBlockBodyPhase0: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					type: {type: "list", limit: 2, children: [{name: "element", type: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					type: {type: "list", limit: 128, children: [{name: "element", type: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
			]
		}

		BeaconBlockPhase0: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
				{
					name: "parent_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					type: {
						type: "ref"
						ref:  "BeaconBlockBodyPhase0"
					}
				},
			]
		}

		SignedBeaconBlockPhase0: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BeaconBlockPhase0"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		BeaconStatePhase0: {
			type: "container"
			children: [
				{
					name: "genesis_time"
					type: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "fork"
					type: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					type: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					type: {type: "list", limit: 2048, children: [{name: "element", type: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					type: {type: "uint64"}
				},
				{
					name: "validators"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					type: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_attestations"
					type: {type: "list", limit: 4096, children: [{name: "element", type: {type: "ref", ref: "PendingAttestation"}},]}
				},
				{
					name: "current_epoch_attestations"
					type: {type: "list", limit: 4096, children: [{name: "element", type: {type: "ref", ref: "PendingAttestation"}},]}
				},
				{
					name: "justification_bits"
					type: {type: "vector", size: 1, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
			]
		}

		// ===== Altair Types =====

		SyncCommittee: {
			type: "container"
			children: [
				{
					name: "pubkeys"
					type: {
						type:   "vector"
						size: 512
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "BLSPubkey"
								}
							},
						]
					}
				},
				{
					name: "aggregate_pubkey"
					type: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
			]
		}

		SyncAggregate: {
			type: "container"
			children: [
				{
					name: "sync_committee_bits"
					type: {type: "vector", size: 64, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "sync_committee_signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		LightClientHeader: {
			type: "container"
			children: [
				{
					name: "beacon"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
			]
		}

		LightClientBootstrap: {
			type: "container"
			children: [
				{
					name: "header"
					type: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "current_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "current_sync_committee_branch"
					type: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
			]
		}

		LightClientFinalityUpdate: {
			type: "container"
			children: [
				{
					name: "attested_header"
					type: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "finalized_header"
					type: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "finality_branch"
					type: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					type: {type: "uint64"}
				},
			]
		}

		LightClientOptimisticUpdate: {
			type: "container"
			children: [
				{
					name: "attested_header"
					type: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					type: {type: "uint64"}
				},
			]
		}

		LightClientUpdate: {
			type: "container"
			children: [
				{
					name: "attested_header"
					type: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "next_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee_branch"
					type: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "finalized_header"
					type: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "finality_branch"
					type: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					type: {type: "uint64"}
				},
			]
		}

		BeaconBlockBodyAltair: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					type: {type: "list", limit: 2, children: [{name: "element", type: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					type: {type: "list", limit: 128, children: [{name: "element", type: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
			]
		}

		BeaconBlockAltair: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
				{
					name: "parent_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					type: {
						type: "ref"
						ref:  "BeaconBlockBodyAltair"
					}
				},
			]
		}

		SignedBeaconBlockAltair: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BeaconBlockAltair"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		BeaconStateAltair: {
			type: "container"
			children: [
				{
					name: "genesis_time"
					type: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "fork"
					type: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					type: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					type: {type: "list", limit: 2048, children: [{name: "element", type: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					type: {type: "uint64"}
				},
				{
					name: "validators"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					type: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_participation"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "current_epoch_participation"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "justification_bits"
					type: {type: "vector", size: 1, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "inactivity_scores"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "current_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
			]
		}

		SyncCommitteeContribution: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "beacon_block_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "subcommittee_index"
					type: {type: "uint64"}
				},
				{
					name: "aggregation_bits"
					type: {type: "vector", size: 16, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		ContributionAndProof: {
			type: "container"
			children: [
				{
					name: "aggregator_index"
					type: {type: "uint64"}
				},
				{
					name: "contribution"
					type: {
						type: "ref"
						ref:  "SyncCommitteeContribution"
					}
				},
				{
					name: "selection_proof"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		SignedContributionAndProof: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "ContributionAndProof"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		SyncCommitteeMessage: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "beacon_block_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "validator_index"
					type: {type: "uint64"}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		SyncAggregatorSelectionData: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "subcommittee_index"
					type: {type: "uint64"}
				},
			]
		}

		// ===== Bellatrix Types =====

		ExecutionPayloadHeader: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					type: {type: "vector", size: 20, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					type: {type: "vector", size: 256, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					type: {type: "uint64"}
				},
				{
					name: "gas_limit"
					type: {type: "uint64"}
				},
				{
					name: "gas_used"
					type: {type: "uint64"}
				},
				{
					name: "timestamp"
					type: {type: "uint64"}
				},
				{
					name: "extra_data"
					type: {type: "list", limit: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					type: {
						type: "ref"
						ref:  "Uint256"
					}
				},
				{
					name: "block_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "transactions_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		ExecutionPayload: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					type: {type: "vector", size: 20, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					type: {type: "vector", size: 256, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					type: {type: "uint64"}
				},
				{
					name: "gas_limit"
					type: {type: "uint64"}
				},
				{
					name: "gas_used"
					type: {type: "uint64"}
				},
				{
					name: "timestamp"
					type: {type: "uint64"}
				},
				{
					name: "extra_data"
					type: {type: "list", limit: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					type: {
						type: "ref"
						ref:  "Uint256"
					}
				},
				{
					name: "block_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "transactions"
					type: {
						type:      "list"
						limit: 1048576
						children: [
							{
								name: "element"
								type: {
									type:      "list"
									limit: 1073741824
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
						]
					}
				},
			]
		}

		BeaconBlockBodyBellatrix: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					type: {type: "list", limit: 2, children: [{name: "element", type: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					type: {type: "list", limit: 128, children: [{name: "element", type: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "execution_payload"
					type: {
						type: "ref"
						ref:  "ExecutionPayload"
					}
				},
			]
		}

		BeaconBlockBellatrix: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
				{
					name: "parent_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					type: {
						type: "ref"
						ref:  "BeaconBlockBodyBellatrix"
					}
				},
			]
		}

		SignedBeaconBlockBellatrix: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BeaconBlockBellatrix"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		BlindedBeaconBlockBody: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					type: {type: "list", limit: 2, children: [{name: "element", type: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					type: {type: "list", limit: 128, children: [{name: "element", type: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "execution_payload_header"
					type: {
						type: "ref"
						ref:  "ExecutionPayloadHeader"
					}
				},
			]
		}

		BlindedBeaconBlock: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
				{
					name: "parent_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					type: {
						type: "ref"
						ref:  "BlindedBeaconBlockBody"
					}
				},
			]
		}

		SignedBlindedBeaconBlock: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BlindedBeaconBlock"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		BeaconStateBellatrix: {
			type: "container"
			children: [
				{
					name: "genesis_time"
					type: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "fork"
					type: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					type: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								type: {
									type:      "list"
									limit: 32
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
						]
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					type: {type: "list", limit: 2048, children: [{name: "element", type: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					type: {type: "uint64"}
				},
				{
					name: "validators"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					type: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_participation"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "current_epoch_participation"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "justification_bits"
					type: {type: "vector", size: 1, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "inactivity_scores"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "current_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "latest_execution_payload_header"
					type: {
						type: "ref"
						ref:  "ExecutionPayloadHeader"
					}
				},
			]
		}

		// ===== Capella Types =====

		Withdrawal: {
			type: "container"
			children: [
				{
					name: "index"
					type: {type: "uint64"}
				},
				{
					name: "validator_index"
					type: {type: "uint64"}
				},
				{
					name: "address"
					type: {type: "vector", size: 20, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "amount"
					type: {type: "uint64"}
				},
			]
		}

		BLSToExecutionChange: {
			type: "container"
			children: [
				{
					name: "validator_index"
					type: {type: "uint64"}
				},
				{
					name: "from_bls_pubkey"
					type: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "to_execution_address"
					type: {type: "vector", size: 20, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		SignedBLSToExecutionChange: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BLSToExecutionChange"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		HistoricalSummary: {
			type: "container"
			children: [
				{
					name: "block_summary_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_summary_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
			]
		}

		ExecutionPayloadHeaderCapella: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					type: {type: "vector", size: 20, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					type: {type: "vector", size: 256, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					type: {type: "uint64"}
				},
				{
					name: "gas_limit"
					type: {type: "uint64"}
				},
				{
					name: "gas_used"
					type: {type: "uint64"}
				},
				{
					name: "timestamp"
					type: {type: "uint64"}
				},
				{
					name: "extra_data"
					type: {type: "list", limit: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					type: {
						type: "ref"
						ref:  "Uint256"
					}
				},
				{
					name: "block_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "transactions_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "withdrawals_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
			]
		}

		ExecutionPayloadCapella: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					type: {type: "vector", size: 20, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					type: {type: "vector", size: 256, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					type: {type: "uint64"}
				},
				{
					name: "gas_limit"
					type: {type: "uint64"}
				},
				{
					name: "gas_used"
					type: {type: "uint64"}
				},
				{
					name: "timestamp"
					type: {type: "uint64"}
				},
				{
					name: "extra_data"
					type: {type: "list", limit: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					type: {
						type: "ref"
						ref:  "Uint256"
					}
				},
				{
					name: "block_hash"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "transactions"
					type: {
						type:      "list"
						limit: 1048576
						children: [
							{
								name: "element"
								type: {
									type:      "list"
									limit: 1073741824
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
						]
					}
				},
				{
					name: "withdrawals"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "Withdrawal"}},]}
				},
			]
		}

		BeaconBlockBodyCapella: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					type: {type: "list", limit: 2, children: [{name: "element", type: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					type: {type: "list", limit: 128, children: [{name: "element", type: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "execution_payload"
					type: {
						type: "ref"
						ref:  "ExecutionPayloadCapella"
					}
				},
				{
					name: "bls_to_execution_changes"
					type: {type: "list", limit: 16, children: [{name: "element", type: {type: "ref", ref: "SignedBLSToExecutionChange"}},]}
				},
			]
		}

		BeaconBlockCapella: {
			type: "container"
			children: [
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {type: "uint64"}
				},
				{
					name: "parent_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					type: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					type: {
						type: "ref"
						ref:  "BeaconBlockBodyCapella"
					}
				},
			]
		}

		SignedBeaconBlockCapella: {
			type: "container"
			children: [
				{
					name: "message"
					type: {
						type: "ref"
						ref:  "BeaconBlockCapella"
					}
				},
				{
					name: "signature"
					type: {
						type: "ref"
						ref:  "Signature"
					}
				},
			]
		}

		BeaconStateCapella: {
			type: "container"
			children: [
				{
					name: "genesis_time"
					type: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					type: {type: "vector", size: 32, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "slot"
					type: {type: "uint64"}
				},
				{
					name: "fork"
					type: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					type: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								type: {
									type:      "list"
									limit: 32
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
						]
					}
				},
				{
					name: "eth1_data"
					type: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					type: {type: "list", limit: 2048, children: [{name: "element", type: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					type: {type: "uint64"}
				},
				{
					name: "validators"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					type: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					type: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								type: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_participation"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "current_epoch_participation"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "justification_bits"
					type: {type: "vector", size: 1, children: [{name: "element", type: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					type: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "inactivity_scores"
					type: {type: "list", limit: 1099511627776, children: [{name: "element", type: {type: "uint64"}},]}
				},
				{
					name: "current_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "latest_execution_payload_header"
					type: {
						type: "ref"
						ref:  "ExecutionPayloadHeaderCapella"
					}
				},
				{
					name: "next_withdrawal_index"
					type: {type: "uint64"}
				},
				{
					name: "next_withdrawal_validator_index"
					type: {type: "uint64"}
				},
				{
					name: "historical_summaries"
					type: {type: "list", limit: 16777216, children: [{name: "element", type: {type: "ref", ref: "HistoricalSummary"}},]}
				},
			]
		}

		LightClientHeaderCapella: {
			type: "container"
			children: [
				{
					name: "beacon"
					type: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "execution"
					type: {
						type: "ref"
						ref:  "ExecutionPayloadHeaderCapella"
					}
				},
				{
					name: "execution_branch"
					type: {
						type:   "vector"
						size: 4
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
			]
		}

		LightClientBootstrapCapella: {
			type: "container"
			children: [
				{
					name: "header"
					type: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "current_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "current_sync_committee_branch"
					type: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
			]
		}

		LightClientFinalityUpdateCapella: {
			type: "container"
			children: [
				{
					name: "attested_header"
					type: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "finalized_header"
					type: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "finality_branch"
					type: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					type: {type: "uint64"}
				},
			]
		}

		LightClientOptimisticUpdateCapella: {
			type: "container"
			children: [
				{
					name: "attested_header"
					type: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					type: {type: "uint64"}
				},
			]
		}

		LightClientUpdateCapella: {
			type: "container"
			children: [
				{
					name: "attested_header"
					type: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "next_sync_committee"
					type: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee_branch"
					type: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "finalized_header"
					type: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "finality_branch"
					type: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								type: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					type: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					type: {type: "uint64"}
				},
			]
		}
	}
}
