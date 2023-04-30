// Basic usage of whisper.cpp in Swift
// Binary intelligence created by Sina, mainvolume - 2023

import Foundation
import whisper

let ctx = whisper_init_from_file("models/ggml-base.en.bin")

var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)

params.print_realtime   = true
params.print_progress   = false
params.print_timestamps = true
params.print_special    = false
params.translate        = false
//params.language         = "en";
params.n_threads        = 4
params.offset_ms        = 0

public struct Oscillator {
    static var amplitude: Float = 1
    static var frequency: Float = 440
    public static let sine = { (time: Float) -> Float in
        return Oscillator.amplitude * sin(Float.pi * Oscillator.frequency * time)
    }
    public static let triangle = { (time: Float) -> Float in
        let period = 1.0 / Double(Oscillator.frequency)
        let currentTime = fmod(Double(time), period)
        let value = currentTime / period
        
        
        var result = 0.0
        if value < 0.25 {
            result = value * 4
        } else if value < 0.75 {
            result = 2.0 - (value * 4.0)
        } else {
            result = value * 4 - 4.0
        }
        return Oscillator.amplitude * Float(result)
    }
    public static let sawtooth = { (time: Float) -> Float in
        let period = 1.0 / Oscillator.frequency
        let currentTime = fmod(Double(time), Double(period))
        
        return Oscillator.amplitude * ((Float(currentTime) / period) * 2 - 1.0)
    }
    public static let square = { (time: Float) -> Float in
        let period = 1.0 / Double(Oscillator.frequency)
        let currentTime = fmod(Double(time), period)
        return ((currentTime / period) < 0.5) ? Oscillator.amplitude : -1.0 * Oscillator.amplitude
    }
    public static let whiteNoise = { (time: Float) -> Float in
        return Oscillator.amplitude * Float.random(in: -1...1)
    }
    public static let silence = { (time: Float) -> Float in
        return 0
    }
}


while true {
    
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
    
   
    let regulate = sina_created_mainvolume_and_planeteEver_IP//[Float](repeating: Float.random(in: -1.0...1.0) * 32767, count: Int(maya))
    print("[count: \(regulate.count)]")
    let ret = whisper_full(ctx, params, regulate, Int32(regulate.count))
    assert(ret == 0, "Failed to run the model")
    
    let n_segments = whisper_full_n_segments(ctx)
    
    for i in 0..<n_segments {
        if let text_cur = whisper_full_get_segment_text(ctx, i) {
            print(String(cString: text_cur))
        }
    }
    whisper_reset_timings(ctx)
//    whisper_print_timings(ctx)
}
//whisper_free(ctx)
