package consensus

import "github.com/gfx-labs/cuessz"

BeaconChain: cuessz.#Schema & {
	metadata: {
		namespace:   "eth2.beacon"
		description: "Ethereum Beacon Chain SSZ types"
		authors: ["gfx labs"]
	}

	defs: {
		// ===== Basic Types =====

		Root: {
			type:   "vector"
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

		Signature: {
			type:   "vector"
			size: 96
			children: [
				{
					name: "element"
					def: {
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
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "root"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "index"
					def: {type: "uint64"}
				},
				{
					name: "beacon_block_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "source"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "target"
					def: {
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
					def: {type: "bitlist", limit: 2048}
				},
				{
					name: "data"
					def: {
						type: "ref"
						ref:  "AttestationData"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "aggregate"
					def: {
						type: "ref"
						ref:  "Attestation"
					}
				},
				{
					name: "selection_proof"
					def: {type: "vector", size: 96, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		SignedAggregateAndProof: {
			type: "container"
			children: [
				{
					name: "message"
					def: {
						type: "ref"
						ref:  "AggregateAndProof"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "withdrawal_credentials"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "amount"
					def: {type: "uint64"}
				},
				{
					name: "signature"
					def: {
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
					def: {
						type:   "vector"
						size: 33
						children: [
							{
								name: "element"
								def: {
									type:   "vector"
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
							},
						]
					}
				},
				{
					name: "data"
					def: {
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
					def: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "withdrawal_credentials"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "amount"
					def: {type: "uint64"}
				},
			]
		}

		IndexedAttestation: {
			type: "container"
			children: [
				{
					name: "attesting_indices"
					def: {type: "list", limit: 2048, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "data"
					def: {
						type: "ref"
						ref:  "AttestationData"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "bitlist", limit: 2048}
				},
				{
					name: "data"
					def: {
						type: "ref"
						ref:  "AttestationData"
					}
				},
				{
					name: "inclusion_delay"
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
			]
		}

		Fork: {
			type: "container"
			children: [
				{
					name: "previous_version"
					def: {type: "vector", size: 4, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "current_version"
					def: {type: "vector", size: 4, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "epoch"
					def: {type: "uint64"}
				},
			]
		}

		Validator: {
			type: "container"
			children: [
				{
					name: "pubkey"
					def: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "withdrawal_credentials"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "effective_balance"
					def: {type: "uint64"}
				},
				{
					name: "slashed"
					def: {type: "boolean"}
				},
				{
					name: "activation_eligibility_epoch"
					def: {type: "uint64"}
				},
				{
					name: "activation_epoch"
					def: {type: "uint64"}
				},
				{
					name: "exit_epoch"
					def: {type: "uint64"}
				},
				{
					name: "withdrawable_epoch"
					def: {type: "uint64"}
				},
			]
		}

		VoluntaryExit: {
			type: "container"
			children: [
				{
					name: "epoch"
					def: {type: "uint64"}
				},
				{
					name: "validator_index"
					def: {type: "uint64"}
				},
			]
		}

		SignedVoluntaryExit: {
			type: "container"
			children: [
				{
					name: "message"
					def: {
						type: "ref"
						ref:  "VoluntaryExit"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type:   "vector"
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
							},
						]
					}
				},
				{
					name: "state_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type:   "vector"
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
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "deposit_count"
					def: {type: "uint64"}
				},
				{
					name: "block_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		SigningRoot: {
			type: "container"
			children: [
				{
					name: "object_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "domain"
					def: {type: "list", limit: 8, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		BeaconBlockHeader: {
			type: "container"
			children: [
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
				{
					name: "parent_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body_root"
					def: {
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
					def: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {
						type: "ref"
						ref:  "SignedBeaconBlockHeader"
					}
				},
				{
					name: "signed_header_2"
					def: {
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
					def: {
						type: "ref"
						ref:  "IndexedAttestation"
					}
				},
				{
					name: "attestation_2"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "recipient"
					def: {type: "uint64"}
				},
				{
					name: "amount"
					def: {type: "uint64"}
				},
				{
					name: "fee"
					def: {type: "uint64"}
				},
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "pubkey"
					def: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "vector", size: 4, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "genesis_validators_root"
					def: {
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
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "domain"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		Eth1Block: {
			type: "container"
			children: [
				{
					name: "timestamp"
					def: {type: "uint64"}
				},
				{
					name: "deposit_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "deposit_count"
					def: {type: "uint64"}
				},
			]
		}

		PowBlock: {
			type: "container"
			children: [
				{
					name: "block_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "parent_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "total_difficulty"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		// ===== Phase 0 Types =====

		BeaconBlockBodyPhase0: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					def: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					def: {type: "list", limit: 2, children: [{name: "element", def: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					def: {type: "list", limit: 128, children: [{name: "element", def: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
			]
		}

		BeaconBlockPhase0: {
			type: "container"
			children: [
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
				{
					name: "parent_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					def: {
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
					def: {
						type: "ref"
						ref:  "BeaconBlockPhase0"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "fork"
					def: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					def: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					def: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					def: {type: "list", limit: 2048, children: [{name: "element", def: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					def: {type: "uint64"}
				},
				{
					name: "validators"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					def: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_attestations"
					def: {type: "list", limit: 4096, children: [{name: "element", def: {type: "ref", ref: "PendingAttestation"}},]}
				},
				{
					name: "current_epoch_attestations"
					def: {type: "list", limit: 4096, children: [{name: "element", def: {type: "ref", ref: "PendingAttestation"}},]}
				},
				{
					name: "justification_bits"
					def: {type: "vector", size: 1, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					def: {
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
					def: {
						type:   "vector"
						size: 512
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "BLSPubkey"
								}
							},
						]
					}
				},
				{
					name: "aggregate_pubkey"
					def: {
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
					def: {type: "vector", size: 64, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "sync_committee_signature"
					def: {
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
					def: {
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
					def: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "current_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "current_sync_committee_branch"
					def: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								def: {
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
					def: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "finalized_header"
					def: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "finality_branch"
					def: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					def: {type: "uint64"}
				},
			]
		}

		LightClientOptimisticUpdate: {
			type: "container"
			children: [
				{
					name: "attested_header"
					def: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					def: {type: "uint64"}
				},
			]
		}

		LightClientUpdate: {
			type: "container"
			children: [
				{
					name: "attested_header"
					def: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "next_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee_branch"
					def: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "finalized_header"
					def: {
						type: "ref"
						ref:  "LightClientHeader"
					}
				},
				{
					name: "finality_branch"
					def: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					def: {type: "uint64"}
				},
			]
		}

		BeaconBlockBodyAltair: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					def: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					def: {type: "list", limit: 2, children: [{name: "element", def: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					def: {type: "list", limit: 128, children: [{name: "element", def: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
				{
					name: "parent_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					def: {
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
					def: {
						type: "ref"
						ref:  "BeaconBlockAltair"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "fork"
					def: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					def: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					def: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					def: {type: "list", limit: 2048, children: [{name: "element", def: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					def: {type: "uint64"}
				},
				{
					name: "validators"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					def: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_participation"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "current_epoch_participation"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "justification_bits"
					def: {type: "vector", size: 1, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "inactivity_scores"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "current_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "beacon_block_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "subcommittee_index"
					def: {type: "uint64"}
				},
				{
					name: "aggregation_bits"
					def: {type: "vector", size: 16, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "contribution"
					def: {
						type: "ref"
						ref:  "SyncCommitteeContribution"
					}
				},
				{
					name: "selection_proof"
					def: {
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
					def: {
						type: "ref"
						ref:  "ContributionAndProof"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "beacon_block_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "validator_index"
					def: {type: "uint64"}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "subcommittee_index"
					def: {type: "uint64"}
				},
			]
		}

		// ===== Bellatrix Types =====

		ExecutionPayloadHeader: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					def: {type: "vector", size: 20, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					def: {type: "vector", size: 256, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					def: {type: "uint64"}
				},
				{
					name: "gas_limit"
					def: {type: "uint64"}
				},
				{
					name: "gas_used"
					def: {type: "uint64"}
				},
				{
					name: "timestamp"
					def: {type: "uint64"}
				},
				{
					name: "extra_data"
					def: {type: "list", limit: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					def: {type: "uint256"}
				},
				{
					name: "block_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "transactions_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		ExecutionPayload: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					def: {type: "vector", size: 20, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					def: {type: "vector", size: 256, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					def: {type: "uint64"}
				},
				{
					name: "gas_limit"
					def: {type: "uint64"}
				},
				{
					name: "gas_used"
					def: {type: "uint64"}
				},
				{
					name: "timestamp"
					def: {type: "uint64"}
				},
				{
					name: "extra_data"
					def: {type: "list", limit: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					def: {type: "uint256"}
				},
				{
					name: "block_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "transactions"
					def: {
						type:      "list"
						limit: 1048576
						children: [
							{
								name: "element"
								def: {
									type:      "list"
									limit: 1073741824
									children: [
										{
											name: "element"
											def: {
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
					def: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					def: {type: "list", limit: 2, children: [{name: "element", def: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					def: {type: "list", limit: 128, children: [{name: "element", def: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "execution_payload"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
				{
					name: "parent_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					def: {
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
					def: {
						type: "ref"
						ref:  "BeaconBlockBellatrix"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					def: {type: "list", limit: 2, children: [{name: "element", def: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					def: {type: "list", limit: 128, children: [{name: "element", def: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "execution_payload_header"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
				{
					name: "parent_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					def: {
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
					def: {
						type: "ref"
						ref:  "BlindedBeaconBlock"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "fork"
					def: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					def: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					def: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								def: {
									type:      "list"
									limit: 32
									children: [
										{
											name: "element"
											def: {
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
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					def: {type: "list", limit: 2048, children: [{name: "element", def: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					def: {type: "uint64"}
				},
				{
					name: "validators"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					def: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_participation"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "current_epoch_participation"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "justification_bits"
					def: {type: "vector", size: 1, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "inactivity_scores"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "current_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "latest_execution_payload_header"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "validator_index"
					def: {type: "uint64"}
				},
				{
					name: "address"
					def: {type: "vector", size: 20, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "amount"
					def: {type: "uint64"}
				},
			]
		}

		BLSToExecutionChange: {
			type: "container"
			children: [
				{
					name: "validator_index"
					def: {type: "uint64"}
				},
				{
					name: "from_bls_pubkey"
					def: {
						type: "ref"
						ref:  "BLSPubkey"
					}
				},
				{
					name: "to_execution_address"
					def: {type: "vector", size: 20, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		SignedBLSToExecutionChange: {
			type: "container"
			children: [
				{
					name: "message"
					def: {
						type: "ref"
						ref:  "BLSToExecutionChange"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_summary_root"
					def: {
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
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					def: {type: "vector", size: 20, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					def: {type: "vector", size: 256, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					def: {type: "uint64"}
				},
				{
					name: "gas_limit"
					def: {type: "uint64"}
				},
				{
					name: "gas_used"
					def: {type: "uint64"}
				},
				{
					name: "timestamp"
					def: {type: "uint64"}
				},
				{
					name: "extra_data"
					def: {type: "list", limit: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					def: {type: "uint256"}
				},
				{
					name: "block_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "transactions_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "withdrawals_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
			]
		}

		ExecutionPayloadCapella: {
			type: "container"
			children: [
				{
					name: "parent_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "fee_recipient"
					def: {type: "vector", size: 20, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "state_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "receipts_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "logs_bloom"
					def: {type: "vector", size: 256, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "prev_randao"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "block_number"
					def: {type: "uint64"}
				},
				{
					name: "gas_limit"
					def: {type: "uint64"}
				},
				{
					name: "gas_used"
					def: {type: "uint64"}
				},
				{
					name: "timestamp"
					def: {type: "uint64"}
				},
				{
					name: "extra_data"
					def: {type: "list", limit: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "base_fee_per_gas"
					def: {type: "uint256"}
				},
				{
					name: "block_hash"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "transactions"
					def: {
						type:      "list"
						limit: 1048576
						children: [
							{
								name: "element"
								def: {
									type:      "list"
									limit: 1073741824
									children: [
										{
											name: "element"
											def: {
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
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "Withdrawal"}},]}
				},
			]
		}

		BeaconBlockBodyCapella: {
			type: "container"
			children: [
				{
					name: "randao_reveal"
					def: {
						type: "ref"
						ref:  "Signature"
					}
				},
				{
					name: "eth1_data"
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "graffiti"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "proposer_slashings"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "ProposerSlashing"}},]}
				},
				{
					name: "attester_slashings"
					def: {type: "list", limit: 2, children: [{name: "element", def: {type: "ref", ref: "AttesterSlashing"}},]}
				},
				{
					name: "attestations"
					def: {type: "list", limit: 128, children: [{name: "element", def: {type: "ref", ref: "Attestation"}},]}
				},
				{
					name: "deposits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "Deposit"}},]}
				},
				{
					name: "voluntary_exits"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "SignedVoluntaryExit"}},]}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "execution_payload"
					def: {
						type: "ref"
						ref:  "ExecutionPayloadCapella"
					}
				},
				{
					name: "bls_to_execution_changes"
					def: {type: "list", limit: 16, children: [{name: "element", def: {type: "ref", ref: "SignedBLSToExecutionChange"}},]}
				},
			]
		}

		BeaconBlockCapella: {
			type: "container"
			children: [
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "proposer_index"
					def: {type: "uint64"}
				},
				{
					name: "parent_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "state_root"
					def: {
						type: "ref"
						ref:  "Root"
					}
				},
				{
					name: "body"
					def: {
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
					def: {
						type: "ref"
						ref:  "BeaconBlockCapella"
					}
				},
				{
					name: "signature"
					def: {
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
					def: {type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					def: {type: "vector", size: 32, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "slot"
					def: {type: "uint64"}
				},
				{
					name: "fork"
					def: {
						type: "ref"
						ref:  "Fork"
					}
				},
				{
					name: "latest_block_header"
					def: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "block_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "state_roots"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "historical_roots"
					def: {
						type:      "list"
						limit: 16777216
						children: [
							{
								name: "element"
								def: {
									type:      "list"
									limit: 32
									children: [
										{
											name: "element"
											def: {
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
					def: {
						type: "ref"
						ref:  "Eth1Data"
					}
				},
				{
					name: "eth1_data_votes"
					def: {type: "list", limit: 2048, children: [{name: "element", def: {type: "ref", ref: "Eth1Data"}},]}
				},
				{
					name: "eth1_deposit_index"
					def: {type: "uint64"}
				},
				{
					name: "validators"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "ref", ref: "Validator"}},]}
				},
				{
					name: "balances"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "randao_mixes"
					def: {
						type:   "vector"
						size: 65536
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "slashings"
					def: {
						type:   "vector"
						size: 8192
						children: [
							{
								name: "element"
								def: {
									type: "uint64"
								}
							},
						]
					}
				},
				{
					name: "previous_epoch_participation"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "current_epoch_participation"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "justification_bits"
					def: {type: "vector", size: 1, children: [{name: "element", def: {type: "uint8"}},]}
				},
				{
					name: "previous_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "current_justified_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "finalized_checkpoint"
					def: {
						type: "ref"
						ref:  "Checkpoint"
					}
				},
				{
					name: "inactivity_scores"
					def: {type: "list", limit: 4294967296, children: [{name: "element", def: {type: "uint64"}},]}
				},
				{
					name: "current_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "latest_execution_payload_header"
					def: {
						type: "ref"
						ref:  "ExecutionPayloadHeaderCapella"
					}
				},
				{
					name: "next_withdrawal_index"
					def: {type: "uint64"}
				},
				{
					name: "next_withdrawal_validator_index"
					def: {type: "uint64"}
				},
				{
					name: "historical_summaries"
					def: {type: "list", limit: 16777216, children: [{name: "element", def: {type: "ref", ref: "HistoricalSummary"}},]}
				},
			]
		}

		LightClientHeaderCapella: {
			type: "container"
			children: [
				{
					name: "beacon"
					def: {
						type: "ref"
						ref:  "BeaconBlockHeader"
					}
				},
				{
					name: "execution"
					def: {
						type: "ref"
						ref:  "ExecutionPayloadHeaderCapella"
					}
				},
				{
					name: "execution_branch"
					def: {
						type:   "vector"
						size: 4
						children: [
							{
								name: "element"
								def: {
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
					def: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "current_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "current_sync_committee_branch"
					def: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								def: {
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
					def: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "finalized_header"
					def: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "finality_branch"
					def: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					def: {type: "uint64"}
				},
			]
		}

		LightClientOptimisticUpdateCapella: {
			type: "container"
			children: [
				{
					name: "attested_header"
					def: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					def: {type: "uint64"}
				},
			]
		}

		LightClientUpdateCapella: {
			type: "container"
			children: [
				{
					name: "attested_header"
					def: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "next_sync_committee"
					def: {
						type: "ref"
						ref:  "SyncCommittee"
					}
				},
				{
					name: "next_sync_committee_branch"
					def: {
						type:   "vector"
						size: 5
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "finalized_header"
					def: {
						type: "ref"
						ref:  "LightClientHeaderCapella"
					}
				},
				{
					name: "finality_branch"
					def: {
						type:   "vector"
						size: 6
						children: [
							{
								name: "element"
								def: {
									type: "ref"
									ref:  "Root"
								}
							},
						]
				}
				},
				{
					name: "sync_aggregate"
					def: {
						type: "ref"
						ref:  "SyncAggregate"
					}
				},
				{
					name: "signature_slot"
					def: {type: "uint64"}
				},
			]
		}
	}
}
