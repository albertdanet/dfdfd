import SwiftUI

@main
struct StrikeForceApp: App {
    var body: some Scene { WindowGroup { GameView() } }
}

struct GameView: View {
    @State private var score = 0
    @State private var ammo = 30
    @State private var targets = Array(repeating: true, count: 9)
    @State private var message = "PRESS START MISSION"
    @State private var started = false
    private let neon = Color(red: 0.20, green: 1.0, blue: 0.58)

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.04, blue: 0.08), Color(red: 0.06, green: 0.10, blue: 0.17)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            VStack(spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("STRIKE").font(.system(size: 32, weight: .black, design: .rounded)).foregroundStyle(.white)
                        Text("FORCE / MOBILE OPS").font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(3).foregroundStyle(neon)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("SCORE").font(.system(size: 10, weight: .bold, design: .monospaced)).foregroundStyle(.gray)
                        Text(String(format: "%04d", score)).font(.system(size: 26, weight: .black, design: .monospaced)).foregroundStyle(neon)
                    }
                }.padding(.top, 12)
                HStack { stat("AMMO", "\(ammo)"); Spacer(); stat("MODE", "TRAINING"); Spacer(); stat("STATUS", ammo > 0 ? "READY" : "RELOAD") }
                    .padding(14).background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.1)))
                ZStack {
                    RoundedRectangle(cornerRadius: 20).fill(Color(red: 0.025, green: 0.065, blue: 0.09))
                    Canvas { ctx, size in
                        for x in stride(from: 0.0, through: size.width, by: 28) { var p = Path(); p.move(to: CGPoint(x:x,y:0)); p.addLine(to: CGPoint(x:x,y:size.height)); ctx.stroke(p, with:.color(neon.opacity(0.08)), lineWidth:1) }
                        for y in stride(from: 0.0, through: size.height, by: 28) { var p = Path(); p.move(to: CGPoint(x:0,y:y)); p.addLine(to: CGPoint(x:size.width,y:y)); ctx.stroke(p, with:.color(neon.opacity(0.08)), lineWidth:1) }
                    }.clipShape(RoundedRectangle(cornerRadius:20))
                    VStack(spacing: 18) {
                        Text("TARGET RANGE // SECTOR 07").font(.system(size:10,weight:.bold,design:.monospaced)).tracking(2).foregroundStyle(neon.opacity(0.85))
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 14) {
                            ForEach(0..<9, id:\.self) { i in
                                Button { shoot(i) } label: {
                                    ZStack {
                                        Circle().fill(targets[i] ? Color.red.opacity(0.12) : neon.opacity(0.08))
                                        Circle().stroke(targets[i] ? Color.red : neon.opacity(0.45), lineWidth: 2)
                                        Circle().stroke(targets[i] ? Color.red.opacity(0.5) : neon.opacity(0.25), lineWidth: 1).padding(9)
                                        Image(systemName: targets[i] ? "scope" : "checkmark").font(.system(size:27,weight:.medium)).foregroundStyle(targets[i] ? Color.red : neon)
                                    }.frame(width:68,height:68)
                                }.buttonStyle(.plain).disabled(!started || !targets[i] || ammo == 0)
                            }
                        }
                        Text(message).font(.system(size:11,weight:.bold,design:.monospaced)).tracking(1).foregroundStyle(.white.opacity(0.75)).multilineTextAlignment(.center)
                    }.padding(18)
                }.frame(maxHeight:.infinity).overlay(RoundedRectangle(cornerRadius:20).stroke(neon.opacity(0.22),lineWidth:1))
                Button {
                    if !started || ammo == 0 || targets.allSatisfy({ !$0 }) { score=0; ammo=30; targets=Array(repeating:true,count:9); message="TAP TARGETS TO SHOOT"; started=true }
                    else { ammo=min(30,ammo+10); message="MAGAZINE RELOADED" }
                } label: {
                    HStack { Image(systemName: (!started || ammo == 0 || targets.allSatisfy({ !$0 })) ? "play.fill" : "arrow.clockwise"); Text(!started ? "START MISSION" : (ammo == 0 || targets.allSatisfy({ !$0 }) ? "PLAY AGAIN" : "RELOAD +10")); Spacer(); Image(systemName:"arrow.right") }
                        .font(.system(size:14,weight:.black,design:.monospaced)).foregroundStyle(.black).padding(18).background(neon,in:RoundedRectangle(cornerRadius:14))
                }
                Text("TRAINING SIMULATION • OFFLINE").font(.system(size:9,weight:.medium,design:.monospaced)).foregroundStyle(.white.opacity(0.35)).tracking(1).padding(.bottom,6)
            }.padding(.horizontal,20).padding(.vertical,8)
        }.preferredColorScheme(.dark)
    }
    private func stat(_ title: String, _ value: String) -> some View {
        VStack(alignment:.leading,spacing:5) { Text(title).font(.system(size:9,weight:.bold,design:.monospaced)).foregroundStyle(.gray); Text(value).font(.system(size:13,weight:.black,design:.monospaced)).foregroundStyle(.white) }
    }
    private func shoot(_ i: Int) {
        guard started, ammo > 0, targets[i] else { return }
        targets[i]=false; ammo -= 1; score += 100
        if targets.allSatisfy({ !$0 }) { message="SECTOR CLEAR — MISSION COMPLETE" }
        else if ammo == 0 { message="OUT OF AMMO — RELOAD OR RESTART" }
        else { message="TARGET DOWN  +100 XP" }
    }
}
