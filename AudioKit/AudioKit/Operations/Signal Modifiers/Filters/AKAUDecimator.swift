//
//  AKAUDecimator.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 11/6/15.
//  Copyright © 2015 AudioKit. All rights reserved.
//

import AVFoundation

/** AudioKit version of Apple's Distortion Audio Unit */
public class AKAUDecimator: AKOperation {
    
    private let cd = AudioComponentDescription(
        componentType: OSType(kAudioUnitType_Effect),
        componentSubType: OSType(kAudioUnitSubType_Distortion),
        componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
        componentFlags: 0,
        componentFlagsMask: 0)
    
    private var internalEffect = AVAudioUnitEffect()
    public var internalAU = AudioUnit()
    
    /** Decimation (Percent) ranges from 0 to 100 (Default: 50) */
    public var decimation: Float = 50 {
        didSet {
            if decimation < 0 {
                decimation = 0
            }
            if decimation > 100 {
                decimation = 100
            }
            AudioUnitSetParameter(internalAU, kDistortionParam_Decimation, kAudioUnitScope_Global, 0, decimation, 0)
        }
    }
    
    /** Rounding (Percent) ranges from 0 to 100 (Default: 0) */
    public var rounding: Float = 0 {
        didSet {
            if rounding < 0 {
                rounding = 0
            }
            if rounding > 100 {
                rounding = 100
            }
            AudioUnitSetParameter(internalAU, kDistortionParam_Rounding, kAudioUnitScope_Global, 0, rounding, 0)
        }
    }
    
        
    /** Mix (Percent) ranges from 0 to 100 (Default: 50) */
    public var mix: Float = 50 {
        didSet {
            if mix < 0 {
                mix = 0
            }
            if mix > 100 {
                mix = 100
            }
            AudioUnitSetParameter(internalAU, kDistortionParam_FinalMix, kAudioUnitScope_Global, 0, mix, 0)
        }
    }
    
    /** Initialize the effect operation */
    public init(_ input: AKOperation) {
        super.init()
        internalEffect = AVAudioUnitEffect(audioComponentDescription: cd)
        output = internalEffect
        AKManager.sharedInstance.engine.attachNode(internalEffect)
        AKManager.sharedInstance.engine.connect(input.output!, to: internalEffect, format: nil)
        internalAU = internalEffect.audioUnit
        
        // Since this is the Decimator, mix it to 100% and use the final mix as the mix parameter
        AudioUnitSetParameter(internalAU, kDistortionParam_DecimationMix, kAudioUnitScope_Global, 0, 100, 0)
    }
}