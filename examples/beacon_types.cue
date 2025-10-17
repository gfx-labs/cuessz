package examples

import "github.com/gfx-labs/cuessz"

// Complete Ethereum Beacon Chain types across all forks (Phase0, Altair, Bellatrix, Capella)

beaconChainTypes: cuessz.#Schema & {
	version: "1.0.0"
	metadata: {
		namespace:   "eth2.beacon"
		description: "Ethereum Beacon Chain SSZ types - all forks"
		authors: ["Ethereum Foundation"]
	}

	types: {
		// ===== Basic Types =====

		Root: {
			kind:   "vector"
			length: 32
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		Signature: {
			kind:   "vector"
			length: 96
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		BLSPubkey: {
			kind:   "vector"
			length: 48
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		Uint256: {
			kind:   "vector"
			length: 32
			elem: {
				kind: "basic"
				type: "uint8"
			}
		}

		// ===== Core Types =====

		Checkpoint: {
			kind: "container"
			fields: [
			{
				name: "epoch"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "root"
				type: Root
			},
			]
		}

		AttestationData: {
			kind: "container"
			fields: [
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "index"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "beacon_block_root"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "source"
				type: Checkpoint
			},
			{
				name: "target"
				type: Checkpoint
			},
			]
		}

		Attestation: {
			kind: "container"
			fields: [
			{
				name: "aggregation_bits"
				type: {kind: "bitlist", maxLength: 2048}
			},
			{
				name: "data"
				type: AttestationData
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		AggregateAndProof: {
			kind: "container"
			fields: [
			{
				name: "aggregator_index"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "aggregate"
				type: Attestation
			},
			{
				name: "selection_proof"
				type: {kind: "vector", length: 96, elem: {kind: "basic", type: "uint8"}}
			},
			]
		}

		SignedAggregateAndProof: {
			kind: "container"
			fields: [
			{
				name: "message"
				type: AggregateAndProof
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		DepositData: {
			kind: "container"
			fields: [
			{
				name: "pubkey"
				type: BLSPubkey
			},
			{
				name: "withdrawal_credentials"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "amount"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		Deposit: {
			kind: "container"
			fields: [
			{
				name: "proof"
				type: {
					kind:   "vector"
					length: 33
					elem: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				}
			},
			{
				name: "data"
				type: DepositData
			},
			]
		}

		DepositMessage: {
			kind: "container"
			fields: [
			{
				name: "pubkey"
				type: BLSPubkey
			},
			{
				name: "withdrawal_credentials"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "amount"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		IndexedAttestation: {
			kind: "container"
			fields: [
			{
				name: "attesting_indices"
				type: {kind: "list", maxLength: 2048, elem: {kind: "basic", type: "uint64"}}
			},
			{
				name: "data"
				type: AttestationData
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		PendingAttestation: {
			kind: "container"
			fields: [
			{
				name: "aggregation_bits"
				type: {kind: "bitlist", maxLength: 2048}
			},
			{
				name: "data"
				type: AttestationData
			},
			{
				name: "inclusion_delay"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "proposer_index"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		Fork: {
			kind: "container"
			fields: [
			{
				name: "previous_version"
				type: {kind: "vector", length: 4, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "current_version"
				type: {kind: "vector", length: 4, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "epoch"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		Validator: {
			kind: "container"
			fields: [
			{
				name: "pubkey"
				type: BLSPubkey
			},
			{
				name: "withdrawal_credentials"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
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
				name: "activation_eligibility_epoch"
				type: {kind: "basic", type: "uint64"}
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

		VoluntaryExit: {
			kind: "container"
			fields: [
			{
				name: "epoch"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "validator_index"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		SignedVoluntaryExit: {
			kind: "container"
			fields: [
			{
				name: "message"
				type: VoluntaryExit
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		HistoricalBatch: {
			kind: "container"
			fields: [
			{
				name: "block_roots"
				type: {
					kind:   "vector"
					length: 8192
					elem: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				}
			},
			{
				name: "state_roots"
				type: {
					kind:   "vector"
					length: 8192
					elem: {
						kind:   "vector"
						length: 32
						elem: {kind: "basic", type: "uint8"}
					}
				}
			},
			]
		}

		Eth1Data: {
			kind: "container"
			fields: [
			{
				name: "deposit_root"
				type: Root
			},
			{
				name: "deposit_count"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "block_hash"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			]
		}

		SigningRoot: {
			kind: "container"
			fields: [
			{
				name: "object_root"
				type: Root
			},
			{
				name: "domain"
				type: {kind: "list", maxLength: 8, elem: {kind: "basic", type: "uint8"}}
			},
			]
		}

		BeaconBlockHeader: {
			kind: "container"
			fields: [
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "proposer_index"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "parent_root"
				type: Root
			},
			{
				name: "state_root"
				type: Root
			},
			{
				name: "body_root"
				type: Root
			},
			]
		}

		SignedBeaconBlockHeader: {
			kind: "container"
			fields: [
			{
				name: "message"
				type: BeaconBlockHeader
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		ProposerSlashing: {
			kind: "container"
			fields: [
			{
				name: "signed_header_1"
				type: SignedBeaconBlockHeader
			},
			{
				name: "signed_header_2"
				type: SignedBeaconBlockHeader
			},
			]
		}

		AttesterSlashing: {
			kind: "container"
			fields: [
			{
				name: "attestation_1"
				type: IndexedAttestation
			},
			{
				name: "attestation_2"
				type: IndexedAttestation
			},
			]
		}

		Transfer: {
			kind: "container"
			fields: [
			{
				name: "sender"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "recipient"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "amount"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "fee"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "pubkey"
				type: BLSPubkey
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		ForkData: {
			kind: "container"
			fields: [
			{
				name: "current_version"
				type: {kind: "vector", length: 4, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "genesis_validators_root"
				type: Root
			},
			]
		}

		SigningData: {
			kind: "container"
			fields: [
			{
				name: "object_root"
				type: Root
			},
			{
				name: "domain"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			]
		}

		Eth1Block: {
			kind: "container"
			fields: [
			{
				name: "timestamp"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "deposit_root"
				type: Root
			},
			{
				name: "deposit_count"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		PowBlock: {
			kind: "container"
			fields: [
			{
				name: "block_hash"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "parent_hash"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "total_difficulty"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			]
		}

		// ===== Phase 0 Types =====

		BeaconBlockBodyPhase0: {
			kind: "container"
			fields: [
			{
				name: "randao_reveal"
				type: Signature
			},
			{
				name: "eth1_data"
				type: Eth1Data
			},
			{
				name: "graffiti"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "proposer_slashings"
				type: {kind: "list", maxLength: 16, elem: ProposerSlashing}
			},
			{
				name: "attester_slashings"
				type: {kind: "list", maxLength: 2, elem: AttesterSlashing}
			},
			{
				name: "attestations"
				type: {kind: "list", maxLength: 128, elem: Attestation}
			},
			{
				name: "deposits"
				type: {kind: "list", maxLength: 16, elem: Deposit}
			},
			{
				name: "voluntary_exits"
				type: {kind: "list", maxLength: 16, elem: SignedVoluntaryExit}
			},
			]
		}

		BeaconBlockPhase0: {
			kind: "container"
			fields: [
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "proposer_index"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "parent_root"
				type: Root
			},
			{
				name: "state_root"
				type: Root
			},
			{
				name: "body"
				type: BeaconBlockBodyPhase0
			},
			]
		}

		SignedBeaconBlockPhase0: {
			kind: "container"
			fields: [
			{
				name: "message"
				type: BeaconBlockPhase0
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		BeaconStatePhase0: {
			kind: "container"
			fields: [
			{
				name: "genesis_time"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "genesis_validators_root"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "fork"
				type: Fork
			},
			{
				name: "latest_block_header"
				type: BeaconBlockHeader
			},
			{
				name: "block_roots"
				type: {
					kind:   "vector"
					length: 8192
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "state_roots"
				type: {
					kind:   "vector"
					length: 8192
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "historical_roots"
				type: {
					kind:      "list"
					maxLength: 16777216
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "eth1_data"
				type: Eth1Data
			},
			{
				name: "eth1_data_votes"
				type: {kind: "list", maxLength: 2048, elem: Eth1Data}
			},
			{
				name: "eth1_deposit_index"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "validators"
				type: {kind: "list", maxLength: 1099511627776, elem: Validator}
			},
			{
				name: "balances"
				type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
			},
			{
				name: "randao_mixes"
				type: {
					kind:   "vector"
					length: 65536
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "slashings"
				type: {
					kind:   "vector"
					length: 8192
					elem: {kind: "basic", type: "uint64"}
				}
			},
			{
				name: "previous_epoch_attestations"
				type: {kind: "list", maxLength: 4096, elem: PendingAttestation}
			},
			{
				name: "current_epoch_attestations"
				type: {kind: "list", maxLength: 4096, elem: PendingAttestation}
			},
			{
				name: "justification_bits"
				type: {kind: "vector", length: 1, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "previous_justified_checkpoint"
				type: Checkpoint
			},
			{
				name: "current_justified_checkpoint"
				type: Checkpoint
			},
			{
				name: "finalized_checkpoint"
				type: Checkpoint
			},
			]
		}

		// ===== Altair Types =====

		SyncCommittee: {
			kind: "container"
			fields: [
			{
				name: "pubkeys"
				type: {
					kind:   "vector"
					length: 512
					elem: BLSPubkey
				}
			},
			{
				name: "aggregate_pubkey"
				type: BLSPubkey
			},
			]
		}

		SyncAggregate: {
			kind: "container"
			fields: [
			{
				name: "sync_committee_bits"
				type: {kind: "vector", length: 64, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "sync_committee_signature"
				type: Signature
			},
			]
		}

		LightClientHeader: {
			kind: "container"
			fields: [
			{
				name: "beacon"
				type: BeaconBlockHeader
			},
			]
		}

		LightClientBootstrap: {
			kind: "container"
			fields: [
			{
				name: "header"
				type: LightClientHeader
			},
			{
				name: "current_sync_committee"
				type: SyncCommittee
			},
			{
				name: "current_sync_committee_branch"
				type: {
					kind:   "vector"
					length: 5
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			]
		}

		LightClientFinalityUpdate: {
			kind: "container"
			fields: [
			{
				name: "attested_header"
				type: LightClientHeader
			},
			{
				name: "finalized_header"
				type: LightClientHeader
			},
			{
				name: "finality_branch"
				type: {
					kind:   "vector"
					length: 6
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "sync_aggregate"
				type: SyncAggregate
			},
			{
				name: "signature_slot"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		LightClientOptimisticUpdate: {
			kind: "container"
			fields: [
			{
				name: "attested_header"
				type: LightClientHeader
			},
			{
				name: "sync_aggregate"
				type: SyncAggregate
			},
			{
				name: "signature_slot"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		LightClientUpdate: {
			kind: "container"
			fields: [
			{
				name: "attested_header"
				type: LightClientHeader
			},
			{
				name: "next_sync_committee"
				type: SyncCommittee
			},
			{
				name: "next_sync_committee_branch"
				type: {
					kind:   "vector"
					length: 5
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "finalized_header"
				type: LightClientHeader
			},
			{
				name: "finality_branch"
				type: {
					kind:   "vector"
					length: 6
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
				name: "sync_aggregate"
				type: SyncAggregate
			},
			{
				name: "signature_slot"
				type: {kind: "basic", type: "uint64"}
			},
			]
		}

		BeaconBlockBodyAltair: {
			kind: "container"
			fields: [
			{
				name: "randao_reveal"
				type: Signature
			},
			{
				name: "eth1_data"
				type: Eth1Data
			},
			{
				name: "graffiti"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "proposer_slashings"
				type: {kind: "list", maxLength: 16, elem: ProposerSlashing}
			},
			{
				name: "attester_slashings"
				type: {kind: "list", maxLength: 2, elem: AttesterSlashing}
			},
			{
				name: "attestations"
				type: {kind: "list", maxLength: 128, elem: Attestation}
			},
			{
				name: "deposits"
				type: {kind: "list", maxLength: 16, elem: Deposit}
			},
			{
				name: "voluntary_exits"
				type: {kind: "list", maxLength: 16, elem: SignedVoluntaryExit}
			},
			{
				name: "sync_aggregate"
				type: SyncAggregate
			},
			]
		}

		BeaconBlockAltair: {
			kind: "container"
			fields: [
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "proposer_index"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "parent_root"
				type: Root
			},
			{
				name: "state_root"
				type: Root
			},
			{
				name: "body"
				type: BeaconBlockBodyAltair
			},
			]
		}

		SignedBeaconBlockAltair: {
			kind: "container"
			fields: [
			{
				name: "message"
				type: BeaconBlockAltair
			},
			{
				name: "signature"
				type: Signature
			},
			]
		}

		BeaconStateAltair: {
			kind: "container"
			fields: [
			{
				name: "genesis_time"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "genesis_validators_root"
				type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
			},
			{
				name: "slot"
				type: {kind: "basic", type: "uint64"}
			},
			{
				name: "fork"
				type: Fork
			},
			{
				name: "latest_block_header"
				type: BeaconBlockHeader
			},
			{
				name: "block_roots"
				type: {
					kind:   "vector"
					length: 8192
					elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				}
			},
			{
name: "state_roots"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "historical_roots"
					type: {
						kind:      "list"
						maxLength: 16777216
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
									},
				{
					name: "eth1_data"
					type: Eth1Data
				},
				{
					name: "eth1_data_votes"
					type: {kind: "list", maxLength: 2048, elem: Eth1Data}
									},
				{
					name: "eth1_deposit_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "validators"
					type: {kind: "list", maxLength: 1099511627776, elem: Validator}
									},
				{
					name: "balances"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
									},
				{
					name: "randao_mixes"
					type: {
						kind:   "vector"
						length: 65536
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "slashings"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "basic", type: "uint64"}
					}
				},
				{
					name: "previous_epoch_participation"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "current_epoch_participation"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "justification_bits"
					type: {kind: "vector", length: 1, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "previous_justified_checkpoint"
					type: Checkpoint
				},
				{
					name: "current_justified_checkpoint"
					type: Checkpoint
				},
				{
					name: "finalized_checkpoint"
					type: Checkpoint
				},
				{
					name: "inactivity_scores"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
									},
				{
					name: "current_sync_committee"
					type: SyncCommittee
				},
				{
					name: "next_sync_committee"
					type: SyncCommittee
				},
			]
		}

		SyncCommitteeContribution: {
			kind: "container"
			fields: [
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "beacon_block_root"
					type: Root
				},
				{
					name: "subcommittee_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "aggregation_bits"
					type: {kind: "vector", length: 16, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		ContributionAndProof: {
			kind: "container"
			fields: [
				{
					name: "aggregator_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "contribution"
					type: SyncCommitteeContribution
				},
				{
					name: "selection_proof"
					type: Signature
				},
			]
		}

		SignedContributionAndProof: {
			kind: "container"
			fields: [
				{
					name: "message"
					type: ContributionAndProof
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		SyncCommitteeMessage: {
			kind: "container"
			fields: [
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "beacon_block_root"
					type: Root
				},
				{
					name: "validator_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		SyncAggregatorSelectionData: {
			kind: "container"
			fields: [
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "subcommittee_index"
					type: {kind: "basic", type: "uint64"}
				},
			]
		}

		// ===== Bellatrix Types =====

		ExecutionPayloadHeader: {
			kind: "container"
			fields: [
				{
					name: "parent_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "fee_recipient"
					type: {kind: "vector", length: 20, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "state_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "receipts_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "logs_bloom"
					type: {kind: "vector", length: 256, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "prev_randao"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
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
					type: {kind: "list", maxLength: 32, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "base_fee_per_gas"
					type: Uint256
				},
				{
					name: "block_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "transactions_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
			]
		}

		ExecutionPayload: {
			kind: "container"
			fields: [
				{
					name: "parent_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "fee_recipient"
					type: {kind: "vector", length: 20, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "state_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "receipts_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "logs_bloom"
					type: {kind: "vector", length: 256, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "prev_randao"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
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
					type: {kind: "list", maxLength: 32, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "base_fee_per_gas"
					type: Uint256
				},
				{
					name: "block_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "transactions"
					type: {
						kind:      "list"
						maxLength: 1048576
						elem: {
							kind:      "list"
							maxLength: 1073741824
							elem: {kind: "basic", type: "uint8"}
						}
					}
									},
			]
		}

		BeaconBlockBodyBellatrix: {
			kind: "container"
			fields: [
				{
					name: "randao_reveal"
					type: Signature
				},
				{
					name: "eth1_data"
					type: Eth1Data
				},
				{
					name: "graffiti"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "proposer_slashings"
					type: {kind: "list", maxLength: 16, elem: ProposerSlashing}
									},
				{
					name: "attester_slashings"
					type: {kind: "list", maxLength: 2, elem: AttesterSlashing}
									},
				{
					name: "attestations"
					type: {kind: "list", maxLength: 128, elem: Attestation}
									},
				{
					name: "deposits"
					type: {kind: "list", maxLength: 16, elem: Deposit}
									},
				{
					name: "voluntary_exits"
					type: {kind: "list", maxLength: 16, elem: SignedVoluntaryExit}
									},
				{
					name: "sync_aggregate"
					type: SyncAggregate
				},
				{
					name: "execution_payload"
					type: ExecutionPayload
				},
			]
		}

		BeaconBlockBellatrix: {
			kind: "container"
			fields: [
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "parent_root"
					type: Root
				},
				{
					name: "state_root"
					type: Root
				},
				{
					name: "body"
					type: BeaconBlockBodyBellatrix
				},
			]
		}

		SignedBeaconBlockBellatrix: {
			kind: "container"
			fields: [
				{
					name: "message"
					type: BeaconBlockBellatrix
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		BlindedBeaconBlockBody: {
			kind: "container"
			fields: [
				{
					name: "randao_reveal"
					type: Signature
				},
				{
					name: "eth1_data"
					type: Eth1Data
				},
				{
					name: "graffiti"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "proposer_slashings"
					type: {kind: "list", maxLength: 16, elem: ProposerSlashing}
									},
				{
					name: "attester_slashings"
					type: {kind: "list", maxLength: 2, elem: AttesterSlashing}
									},
				{
					name: "attestations"
					type: {kind: "list", maxLength: 128, elem: Attestation}
									},
				{
					name: "deposits"
					type: {kind: "list", maxLength: 16, elem: Deposit}
									},
				{
					name: "voluntary_exits"
					type: {kind: "list", maxLength: 16, elem: SignedVoluntaryExit}
									},
				{
					name: "sync_aggregate"
					type: SyncAggregate
				},
				{
					name: "execution_payload_header"
					type: ExecutionPayloadHeader
				},
			]
		}

		BlindedBeaconBlock: {
			kind: "container"
			fields: [
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "parent_root"
					type: Root
				},
				{
					name: "state_root"
					type: Root
				},
				{
					name: "body"
					type: BlindedBeaconBlockBody
				},
			]
		}

		SignedBlindedBeaconBlock: {
			kind: "container"
			fields: [
				{
					name: "message"
					type: BlindedBeaconBlock
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		BeaconStateBellatrix: {
			kind: "container"
			fields: [
				{
					name: "genesis_time"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "fork"
					type: Fork
				},
				{
					name: "latest_block_header"
					type: BeaconBlockHeader
				},
				{
					name: "block_roots"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "state_roots"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "historical_roots"
					type: {
						kind:      "list"
						maxLength: 16777216
						elem: {
							kind:      "list"
							maxLength: 32
							elem: {kind: "basic", type: "uint8"}
						}
					}
									},
				{
					name: "eth1_data"
					type: Eth1Data
				},
				{
					name: "eth1_data_votes"
					type: {kind: "list", maxLength: 2048, elem: Eth1Data}
									},
				{
					name: "eth1_deposit_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "validators"
					type: {kind: "list", maxLength: 1099511627776, elem: Validator}
									},
				{
					name: "balances"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
									},
				{
					name: "randao_mixes"
					type: {
						kind:   "vector"
						length: 65536
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "slashings"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "basic", type: "uint64"}
					}
				},
				{
					name: "previous_epoch_participation"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "current_epoch_participation"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "justification_bits"
					type: {kind: "vector", length: 1, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "previous_justified_checkpoint"
					type: Checkpoint
				},
				{
					name: "current_justified_checkpoint"
					type: Checkpoint
				},
				{
					name: "finalized_checkpoint"
					type: Checkpoint
				},
				{
					name: "inactivity_scores"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
									},
				{
					name: "current_sync_committee"
					type: SyncCommittee
				},
				{
					name: "next_sync_committee"
					type: SyncCommittee
				},
				{
					name: "latest_execution_payload_header"
					type: ExecutionPayloadHeader
				},
			]
		}

		// ===== Capella Types =====

		Withdrawal: {
			kind: "container"
			fields: [
				{
					name: "index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "validator_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "address"
					type: {kind: "vector", length: 20, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "amount"
					type: {kind: "basic", type: "uint64"}
				},
			]
		}

		BLSToExecutionChange: {
			kind: "container"
			fields: [
				{
					name: "validator_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "from_bls_pubkey"
					type: BLSPubkey
				},
				{
					name: "to_execution_address"
					type: {kind: "vector", length: 20, elem: {kind: "basic", type: "uint8"}}
				},
			]
		}

		SignedBLSToExecutionChange: {
			kind: "container"
			fields: [
				{
					name: "message"
					type: BLSToExecutionChange
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		HistoricalSummary: {
			kind: "container"
			fields: [
				{
					name: "block_summary_root"
					type: Root
				},
				{
					name: "state_summary_root"
					type: Root
				},
			]
		}

		ExecutionPayloadHeaderCapella: {
			kind: "container"
			fields: [
				{
					name: "parent_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "fee_recipient"
					type: {kind: "vector", length: 20, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "state_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "receipts_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "logs_bloom"
					type: {kind: "vector", length: 256, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "prev_randao"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
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
					type: {kind: "list", maxLength: 32, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "base_fee_per_gas"
					type: Uint256
				},
				{
					name: "block_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "transactions_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "withdrawals_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
			]
		}

		ExecutionPayloadCapella: {
			kind: "container"
			fields: [
				{
					name: "parent_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "fee_recipient"
					type: {kind: "vector", length: 20, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "state_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "receipts_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "logs_bloom"
					type: {kind: "vector", length: 256, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "prev_randao"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
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
					type: {kind: "list", maxLength: 32, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "base_fee_per_gas"
					type: Uint256
				},
				{
					name: "block_hash"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "transactions"
					type: {
						kind:      "list"
						maxLength: 1048576
						elem: {
							kind:      "list"
							maxLength: 1073741824
							elem: {kind: "basic", type: "uint8"}
						}
					}
									},
				{
					name: "withdrawals"
					type: {kind: "list", maxLength: 16, elem: Withdrawal}
									},
			]
		}

		BeaconBlockBodyCapella: {
			kind: "container"
			fields: [
				{
					name: "randao_reveal"
					type: Signature
				},
				{
					name: "eth1_data"
					type: Eth1Data
				},
				{
					name: "graffiti"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "proposer_slashings"
					type: {kind: "list", maxLength: 16, elem: ProposerSlashing}
									},
				{
					name: "attester_slashings"
					type: {kind: "list", maxLength: 2, elem: AttesterSlashing}
									},
				{
					name: "attestations"
					type: {kind: "list", maxLength: 128, elem: Attestation}
									},
				{
					name: "deposits"
					type: {kind: "list", maxLength: 16, elem: Deposit}
									},
				{
					name: "voluntary_exits"
					type: {kind: "list", maxLength: 16, elem: SignedVoluntaryExit}
									},
				{
					name: "sync_aggregate"
					type: SyncAggregate
				},
				{
					name: "execution_payload"
					type: ExecutionPayloadCapella
				},
				{
					name: "bls_to_execution_changes"
					type: {kind: "list", maxLength: 16, elem: SignedBLSToExecutionChange}
									},
			]
		}

		BeaconBlockCapella: {
			kind: "container"
			fields: [
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "proposer_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "parent_root"
					type: Root
				},
				{
					name: "state_root"
					type: Root
				},
				{
					name: "body"
					type: BeaconBlockBodyCapella
				},
			]
		}

		SignedBeaconBlockCapella: {
			kind: "container"
			fields: [
				{
					name: "message"
					type: BeaconBlockCapella
				},
				{
					name: "signature"
					type: Signature
				},
			]
		}

		BeaconStateCapella: {
			kind: "container"
			fields: [
				{
					name: "genesis_time"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "genesis_validators_root"
					type: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "slot"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "fork"
					type: Fork
				},
				{
					name: "latest_block_header"
					type: BeaconBlockHeader
				},
				{
					name: "block_roots"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "state_roots"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "historical_roots"
					type: {
						kind:      "list"
						maxLength: 16777216
						elem: {
							kind:      "list"
							maxLength: 32
							elem: {kind: "basic", type: "uint8"}
						}
					}
									},
				{
					name: "eth1_data"
					type: Eth1Data
				},
				{
					name: "eth1_data_votes"
					type: {kind: "list", maxLength: 2048, elem: Eth1Data}
									},
				{
					name: "eth1_deposit_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "validators"
					type: {kind: "list", maxLength: 1099511627776, elem: Validator}
									},
				{
					name: "balances"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
									},
				{
					name: "randao_mixes"
					type: {
						kind:   "vector"
						length: 65536
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "slashings"
					type: {
						kind:   "vector"
						length: 8192
						elem: {kind: "basic", type: "uint64"}
					}
				},
				{
					name: "previous_epoch_participation"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "current_epoch_participation"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint8"}}
									},
				{
					name: "justification_bits"
					type: {kind: "vector", length: 1, elem: {kind: "basic", type: "uint8"}}
				},
				{
					name: "previous_justified_checkpoint"
					type: Checkpoint
				},
				{
					name: "current_justified_checkpoint"
					type: Checkpoint
				},
				{
					name: "finalized_checkpoint"
					type: Checkpoint
				},
				{
					name: "inactivity_scores"
					type: {kind: "list", maxLength: 1099511627776, elem: {kind: "basic", type: "uint64"}}
									},
				{
					name: "current_sync_committee"
					type: SyncCommittee
				},
				{
					name: "next_sync_committee"
					type: SyncCommittee
				},
				{
					name: "latest_execution_payload_header"
					type: ExecutionPayloadHeaderCapella
				},
				{
					name: "next_withdrawal_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "next_withdrawal_validator_index"
					type: {kind: "basic", type: "uint64"}
				},
				{
					name: "historical_summaries"
					type: {kind: "list", maxLength: 16777216, elem: HistoricalSummary}
									},
			]
		}

		LightClientHeaderCapella: {
			kind: "container"
			fields: [
				{
					name: "beacon"
					type: BeaconBlockHeader
				},
				{
					name: "execution"
					type: ExecutionPayloadHeaderCapella
				},
				{
					name: "execution_branch"
					type: {
						kind:   "vector"
						length: 4
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
			]
		}

		LightClientBootstrapCapella: {
			kind: "container"
			fields: [
				{
					name: "header"
					type: LightClientHeaderCapella
				},
				{
					name: "current_sync_committee"
					type: SyncCommittee
				},
				{
					name: "current_sync_committee_branch"
					type: {
						kind:   "vector"
						length: 5
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
			]
		}

		LightClientFinalityUpdateCapella: {
			kind: "container"
			fields: [
				{
					name: "attested_header"
					type: LightClientHeaderCapella
				},
				{
					name: "finalized_header"
					type: LightClientHeaderCapella
				},
				{
					name: "finality_branch"
					type: {
						kind:   "vector"
						length: 6
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "sync_aggregate"
					type: SyncAggregate
				},
				{
					name: "signature_slot"
					type: {kind: "basic", type: "uint64"}
				},
			]
		}

		LightClientOptimisticUpdateCapella: {
			kind: "container"
			fields: [
				{
					name: "attested_header"
					type: LightClientHeaderCapella
				},
				{
					name: "sync_aggregate"
					type: SyncAggregate
				},
				{
					name: "signature_slot"
					type: {kind: "basic", type: "uint64"}
				},
			]
		}

		LightClientUpdateCapella: {
			kind: "container"
			fields: [
				{
					name: "attested_header"
					type: LightClientHeaderCapella
				},
				{
					name: "next_sync_committee"
					type: SyncCommittee
				},
				{
					name: "next_sync_committee_branch"
					type: {
						kind:   "vector"
						length: 5
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "finalized_header"
					type: LightClientHeaderCapella
				},
				{
					name: "finality_branch"
					type: {
						kind:   "vector"
						length: 6
						elem: {kind: "vector", length: 32, elem: {kind: "basic", type: "uint8"}}
					}
				},
				{
					name: "sync_aggregate"
					type: SyncAggregate
				},
				{
					name: "signature_slot"
					type: {kind: "basic", type: "uint64"}
				},
			]
		}
	}
}
