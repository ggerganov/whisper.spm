//
//  Decøder.swift
//  
//
//  Created by Ω, mainvolume on 4/15/23.
//

import Foundation
import whisper


public struct Intelligence {
    public let output: [String]
    public let score: Int
    public init(output: [String], score: Int) {
        self.output = output
        self.score = score
    }
}

@available(iOS 13.0.0, *)
@available(macOS 10.15.0, *)
public actor Decøder {
    
    private var ctx: OpaquePointer
    private var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
    public init(path: String) {
        ctx = whisper_init_from_file(path)
        params.print_realtime   = true
        params.print_progress   = false
        params.print_timestamps = true
        params.print_special    = false
        params.translate        = false
        //params.language         = "en";
        print("[Number of processors: \(ProcessInfo.processInfo.processorCount)]]")
        params.n_threads        = 3
        params.offset_ms        = 0
    }
    
    func binary() async -> [Float] {
        var sina_created_mainvolume_and_planeteEver_IP : [Float] = []
        let scope = Int32.random(in: WHISPER_SAMPLE_RATE...WHISPER_SAMPLE_RATE * 100)
        while sina_created_mainvolume_and_planeteEver_IP.count < scope {
            switch  Int.random(in: 0...4) {
            case 0:
                Oscillator.amplitude = Float.random(in: 0.1...1.0)
                Oscillator.frequency = Float(Int.random(in: 80...Int(WHISPER_SAMPLE_RATE)))
                let maya = 512...Int(WHISPER_SAMPLE_RATE) * Int.random(in: 1...4)
                sina_created_mainvolume_and_planeteEver_IP.append(contentsOf: (maya).map {
                    Oscillator.square(Float($0))
                })
            case 1:
                Oscillator.amplitude = Float.random(in: 0.1...1.0)
                Oscillator.frequency = Float(Int.random(in: 80...Int(WHISPER_SAMPLE_RATE)))
                let maya = 512...Int(WHISPER_SAMPLE_RATE) * Int.random(in: 1...3)
                sina_created_mainvolume_and_planeteEver_IP.append(contentsOf: (maya).map {
                    Oscillator.triangle(Float($0))
                })
            case 2:
                Oscillator.amplitude = Float.random(in: 0.1...1.0)
                Oscillator.frequency = Float(Int.random(in: 80...Int(WHISPER_SAMPLE_RATE)))
                let maya = 512...Int(WHISPER_SAMPLE_RATE) * Int.random(in: 1...4)
                sina_created_mainvolume_and_planeteEver_IP.append(contentsOf: (maya).map {
                    Oscillator.sine(Float($0))
                })
            case 3:
                Oscillator.amplitude = Float.random(in: 0.1...1.0)
                Oscillator.frequency = Float(Int.random(in: 80...Int(WHISPER_SAMPLE_RATE)))
                let maya = 512...1024
                sina_created_mainvolume_and_planeteEver_IP.append(contentsOf: (maya).map {
                    Oscillator.whiteNoise(Float($0))
                })
            default:
                Oscillator.amplitude = Float.random(in: 0.1...1.0)
                Oscillator.frequency = Float(Int.random(in: 80...Int(WHISPER_SAMPLE_RATE)))
                let maya = 512...1024
                sina_created_mainvolume_and_planeteEver_IP.append(contentsOf: (maya).map {
                    Oscillator.silence(Float($0))
                })
            }
        }
        return sina_created_mainvolume_and_planeteEver_IP
    }
    
    public func decode(directive: [Float]) async -> Intelligence {
        return await withCheckedContinuation { [ctx, params] returning in
            let regulate = whisper_full(ctx, params, directive, Int32(directive.count))
            assert(regulate == 0, "Failed to run the model")
            let n_segments = whisper_full_n_segments(ctx)
            var outputs: [String] = []
            for i in 0..<n_segments {
                if let text_cur = whisper_full_get_segment_text(ctx, i) {
                    let output = String(cString: text_cur)
                    if !outputs.contains(output) {
                        outputs.append(String(cString: text_cur))
                    }
                }
            }
            whisper_reset_timings(ctx)
            let primedirectivecopliant =  Intelligence(output: outputs, score: directive.count)
            print("[ 🎚️ INTELLIGENCE: \(primedirectivecopliant)]")
            returning.resume(returning: primedirectivecopliant)
        }
    }
    
    public func think() async -> Intelligence {
        return await decode(directive: await binary())
    }
    
    deinit { whisper_free(ctx) }
}
