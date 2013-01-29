import lldb

# valueObject -> SBValue
# dictionary -> do not touch
def magicOptionsSummary(valueObject, dictionary):
    
    emitterInstanceCountIvar = valueObject.GetChildMemberWithName('_emitterInstanceCount')
    emitterInstanceCount = emitterInstanceCountIvar.GetValueAsUnsigned(0)
    emitterInstanceCountAsString = str(emitterInstanceCount)
    
    error = lldb.SBError()
    animationDurationIvar = valueObject.GetChildMemberWithName('_animationDuration')
    animationDuration = animationDurationIvar.GetData().GetFloat(error, 0)
    animationDurationAsString = str(animationDuration)
    
    rotationConstantIvar = valueObject.GetChildMemberWithName('_rotationConstant')
    rotationConstant = rotationConstantIvar.GetValueAsUnsigned(0)
    rotationConstantAsString = str(rotationConstant)
    
    return 'Emitter Instance Count=' + emitterInstanceCountAsString + '; Animation Duration=' + animationDurationAsString + '; Rotation Constant=' + rotationConstantAsString


# Called by LLDB when the script is imported
def __lldb_init_module(debugger, dictionary):
    debugger.HandleCommand('type summary add BTSMagicOptions -F OptionsSummary.magicOptionsSummary')