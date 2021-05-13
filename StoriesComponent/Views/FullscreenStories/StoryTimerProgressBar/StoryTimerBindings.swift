import Foundation

public class StoryTimerBindings {
    typealias StartTimerBind = (TimeInterval) -> Void
    typealias ResumeTimerBind = () -> Void
    typealias PauseTimerBind = () -> Void
    typealias CompleteTimerBind = () -> Void
    typealias ResetTimerBind = () -> Void
    
    let start: StartTimerBind
    let resume: ResumeTimerBind
    let pause: PauseTimerBind
    let complete: CompleteTimerBind
    let reset: ResetTimerBind
    
    init(start: @escaping StartTimerBind,
         resume: @escaping ResumeTimerBind,
         pause: @escaping PauseTimerBind,
         complete: @escaping CompleteTimerBind,
         reset: @escaping ResumeTimerBind) {
        self.start = start
        self.resume = resume
        self.pause = pause
        self.complete = complete
        self.reset = reset
    }
}
