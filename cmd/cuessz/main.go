package main

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/gfx-labs/cuessz"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	command := os.Args[1]

	switch command {
	case "vet":
		if len(os.Args) < 3 {
			fmt.Fprintf(os.Stderr, "Usage: cuessz vet <file1> [file2] ...\n")
			os.Exit(1)
		}
		os.Exit(vetCommand(os.Args[2:]))
	case "help", "-h", "--help":
		printUsage()
		os.Exit(0)
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n\n", command)
		printUsage()
		os.Exit(1)
	}
}

func printUsage() {
	fmt.Println(`cuessz - SSZ schema validation tool

Usage:
  cuessz vet <file1> [file2] ...    Validate JSON schema files
  cuessz vet -                      Read JSON schema from stdin
  cuessz help                       Show this help message

Examples:
  cuessz vet schema.json            Validate a JSON schema file
  cuessz vet *.json                 Validate multiple JSON files
  cuessz vet -                      Validate JSON from stdin
  cat schema.json | cuessz vet -    Pipe JSON to validator
  cue export schema.cue | cuessz vet -    Export CUE to JSON and validate

Exit codes:
  0 - All files valid
  1 - Validation errors found or usage error`)
}

func vetCommand(files []string) int {
	if len(files) == 0 {
		fmt.Fprintf(os.Stderr, "Error: no files specified\n")
		return 1
	}

	totalFiles := 0
	totalErrors := 0

	for _, file := range files {
		totalFiles++

		var err error
		var data []byte

		if file == "-" {
			// Read from stdin
			data, err = io.ReadAll(os.Stdin)
			if err != nil {
				fmt.Fprintf(os.Stderr, "❌ stdin: failed to read: %v\n", err)
				totalErrors++
				continue
			}
			file = "stdin"
		} else {
			// Read from file
			ext := strings.ToLower(filepath.Ext(file))
			if ext != ".json" {
				fmt.Fprintf(os.Stderr, "❌ %s: unsupported file type (must be .json)\n", file)
				totalErrors++
				continue
			}

			data, err = os.ReadFile(file)
			if err != nil {
				fmt.Fprintf(os.Stderr, "❌ %s: failed to read file: %v\n", file, err)
				totalErrors++
				continue
			}
		}

		// Validate the JSON data
		_, err = cuessz.ParseJSON(data)
		if err != nil {
			fmt.Printf("❌ %s: %v\n", file, err)
			totalErrors++
		} else {
			fmt.Printf("✓ %s: valid\n", file)
		}
	}

	fmt.Printf("\n")
	if totalErrors == 0 {
		fmt.Printf("All %d file(s) valid\n", totalFiles)
		return 0
	} else {
		fmt.Fprintf(os.Stderr, "%d of %d file(s) failed validation\n", totalErrors, totalFiles)
		return 1
	}
}

