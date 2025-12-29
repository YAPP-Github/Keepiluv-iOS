//
//  GenerateModule.swift
//  Manifests
//
//  Created by 정지훈 on 12/19/25.
//

//#!/usr/bin/swift
import Foundation

enum Layer: String {
    case feature = "Feature"
    case domain = "Domain"
    case core = "Core"
    case shared = "Shared"
}

enum MicroTarget: String, CaseIterable {
    case example = "Example"
    case sources = "Sources"
    case tests = "Tests"
    case testing = "Testing"
    case interface = "Interface"
}

enum Author: String, CaseIterable {
    case jihun = "Jihun"
    case jiyong = "Jiyong"
}


func convertFirstLowercased(string: String) -> String {
    return String(string.prefix(1)).lowercased() + String(string.dropFirst())
}

let fileManager = FileManager.default
let currentPath = "./"
let bash = Bash()

func registerModuleDependency() {
    registerModule()
    makeProjectDirectory()
    
    var targetString = "["
    
    if hasInterface {
        makeScaffold(target: .interface)
        makeScaffold(target: .sources)
        targetString += """

            .\(lowercasedLayer)(
                interface: .\(lowercasedModuleName),
                config: .init()
            ),
            .\(lowercasedLayer)(
                implements: .\(lowercasedModuleName),
                config: .init(
                    dependencies: [
                        .\(lowercasedLayer)(interface: .\(lowercasedModuleName))
                    ]
                )
            )
    """
    } else {
        makeScaffold(target: .sources)
        targetString += """
        
            .\(lowercasedLayer)(
                implements: .\(lowercasedModuleName),
                config: .init()
            )
    """
    }
    
    
    if hasUnitTests {
        makeScaffold(target: .testing)
        makeScaffold(target: .tests)
        targetString += ","
        
        if hasInterface {
            targetString += """
        
                .\(lowercasedLayer)(
                    testing: .\(lowercasedModuleName),
                    config: .init(
                        dependencies: [
                            .\(lowercasedLayer)(interface: .\(lowercasedModuleName))
                        ]
                    )
                ),
                .\(lowercasedLayer)(
                    tests: .\(lowercasedModuleName),
                    config: .init(
                        dependencies: [
                            .\(lowercasedLayer)(testing: .\(lowercasedModuleName))
                        ]
                    )
                )
        """
        } else {
            targetString += """
        
                .\(lowercasedLayer)(
                    testing: .\(lowercasedModuleName),
                    config: .init(
                        dependencies: [
                            .\(lowercasedLayer)(implements: .\(lowercasedModuleName))
                        ]
                    )
                ),
                .\(lowercasedLayer)(
                    tests: .\(lowercasedModuleName),
                    config: .init(
                        dependencies: [
                            .\(lowercasedLayer)(testing: .\(lowercasedModuleName))
                        ]
                    )
                )
        """
        }
    }

    if hasExample {
        makeScaffold(target: .example)
        targetString += ","
        if hasInterface {
            targetString += """
            
                .\(lowercasedLayer)(
                    example: .\(lowercasedModuleName),
                    config: .init(
                        dependencies: [
                            .\(lowercasedLayer)(interface: .\(lowercasedModuleName))
                        ]
                    )
                )
        """
        } else {
            targetString += """
            
                .\(lowercasedLayer)(
                    example: .\(lowercasedModuleName),
                    config: .init(
                        dependencies: [
                            .\(lowercasedLayer)(implements: .\(lowercasedModuleName))
                        ]
                    )
                )
        """
        }
    }
    
    if targetString.hasSuffix(", ") {
        targetString.removeLast(2)
    }
    
    targetString += """
    
        ]
    """
    
    makeProjectSwift(targetString: targetString)
}

func registerModule() {
    updateFileContent(
        filePath: currentPath + "Tuist/ProjectDescriptionHelpers/Module.swift",
        finding: "enum \(layer.rawValue): String, CaseIterable {\n",
        inserting: "        case \(lowercasedModuleName) = \"\(moduleName)\"\n"
    )
    print("✅ Register \(layer.rawValue)Layer's \(moduleName)Module to Module.swift")
}


func makeDirectory(path: String) {
    do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    } catch {
        fatalError("❌ failed to create directory: \(path)")
    }
}

func makeDirectories(_ paths: [String]) {
    paths.forEach(makeDirectory(path:))
}

func makeProjectSwift(targetString: String) {
    let projectSwift = """
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Module.\(layer.rawValue).name + Module.\(layer.rawValue).\(lowercasedModuleName).rawValue,
    targets: \(targetString)
)
"""
    writeContentInFile(
        path: currentPath + "Projects/\(layer.rawValue)/\(moduleName)/Project.swift",
        content: projectSwift
    )
}

func makeProjectDirectory() {
    makeDirectory(path: currentPath + "Projects/\(layer.rawValue)/\(moduleName)")
}

func makeProjectScaffold(targetString: String) {
    _ = try? bash.run(
        commandName: "tuist",
        arguments: [
            "scaffold",
            "Module",
            "--name", "\(moduleName)",
            "--layer", "\(layer.rawValue)",
            "--target", "\(targetString)",
            "--author", "\(author.rawValue)",
            "--date", "\(currentDate)"
        ]
    )
}

func makeScaffold(target: MicroTarget) {
    _ = try? bash.run(
        commandName: "tuist",
        arguments: [
            "scaffold",
            "\(target.rawValue)",
            "--name", "\(moduleName)",
            "--layer", "\(layer.rawValue)",
            "--author", "\(author.rawValue)",
            "--date", "\(currentDate)"
        ]
    )
}

func writeContentInFile(path: String, content: String) {
    let fileURL = URL(fileURLWithPath: path)
    let data = Data(content.utf8)
    try? data.write(to: fileURL)
}

func updateFileContent(
    filePath: String,
    finding findingString: String,
    inserting insertString: String
) {
    let fileURL = URL(fileURLWithPath: filePath)
    guard let readHandle = try? FileHandle(forReadingFrom: fileURL) else {
        fatalError("❌ Failed to find \(filePath)")
    }
    guard let readData = try? readHandle.readToEnd() else {
        fatalError("❌ Failed to find \(filePath)")
    }
    try? readHandle.close()

    guard var fileString = String(data: readData, encoding: .utf8) else { fatalError() }
    fileString.insert(contentsOf: insertString, at: fileString.range(of: findingString)?.upperBound ?? fileString.endIndex)

    guard let writeHandle = try? FileHandle(forWritingTo: fileURL) else {
        fatalError("❌ Failed to find \(filePath)")
    }
    writeHandle.seek(toFileOffset: 0)
    try? writeHandle.write(contentsOf: Data(fileString.utf8))
    try? writeHandle.close()
}


// MARK: - Starting point

func readNonEmptyLine(prompt: String) -> String {
    while true {
        print(prompt, terminator: " : ")
        if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty {
            return input
        }
        print("Input is empty. Try again.")
    }
}

func selectLayer() -> Layer {
    let layers: [Layer] = [.feature, .domain, .core, .shared]
    while true {
        print("Select layer")
        for (idx, layer) in layers.enumerated() {
            print("  \(idx + 1)) \(layer.rawValue)")
        }
        let input = readNonEmptyLine(prompt: "Enter number (1-\(layers.count))")
        if let choice = Int(input), (1...layers.count).contains(choice) {
            return layers[choice - 1]
        }
        print("Invalid selection. Please enter a number between 1 and \(layers.count).\n")
    }
}

func selectAuthor() -> Author {
    let authors = Author.allCases
    while true {
        print("Select author")
        for (idx, author) in authors.enumerated() {
            print("  \(idx + 1)) \(author.rawValue)")
        }
        let input = readNonEmptyLine(prompt: "Enter number (1-\(authors.count))")
        if let choice = Int(input), (1...authors.count).contains(choice) {
            return authors[choice - 1]
        }
        print("Invalid selection. Please enter a number between 1 and \(authors.count).\n")
    }
}

func todayDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yy"
    return formatter.string(from: Date())
}

let layer = selectLayer()
print("Layer: \(layer.rawValue)\n")

let moduleName = readNonEmptyLine(prompt: "Enter module name")
print("Module name: \(moduleName)\n")

let lowercasedModuleName = convertFirstLowercased(string: moduleName)
let lowercasedLayer = layer.rawValue.lowercased()

let author = selectAuthor()
let currentDate = todayDateString()

print("This module has a 'Tests' Target? (y/n, default = n)", terminator: " : ")
let hasUnitTests = (readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "y")

let hasInterface = layer != .shared
var hasExample = false
if layer.rawValue == "Feature" {
    print("This module has a 'Example' Target? (y/n, default = n)", terminator: " : ")
    hasExample = (readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "y")
}

print("")

registerModuleDependency()

print("")
print("------------------------------------------------------------------------------------------------------------------------")
print("Layer: \(layer.rawValue)")
print("Module name: \(moduleName)")
print("unitTests: \(hasUnitTests), example: \(hasExample)")
print("------------------------------------------------------------------------------------------------------------------------")
print("✅ Module is created successfully!")



// MARK: - Bash
protocol CommandExecuting {
    func run(commandName: String, arguments: [String]) throws -> String
}

enum BashError: Error {
    case commandNotFound(name: String)
}

struct Bash: CommandExecuting {
    func run(commandName: String, arguments: [String] = []) throws -> String {
        return try run(resolve(commandName), with: arguments)
    }

    private func resolve(_ command: String) throws -> String {
        guard var bashCommand = try? run("/bin/bash" , with: ["-l", "-c", "which \(command)"]) else {
            throw BashError.commandNotFound(name: command)
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return bashCommand
    }

    private func run(_ command: String, with arguments: [String] = []) throws -> String {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.launch()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}
