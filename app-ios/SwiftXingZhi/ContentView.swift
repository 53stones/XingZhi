import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack {
            MountainBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .mutualAid:
                        MutualAidView()
                    case .agent:
                        AgentView()
                    case .messages:
                        MessageView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                BottomNavigation(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

private enum AppTab: String, CaseIterable {
    case home = "首页"
    case messages = "消息"
    case mutualAid = "求助"
    case agent = "智能"
    case profile = "我的"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .messages: return "message.fill"
        case .mutualAid: return "cross.case.fill"
        case .agent: return "brain.head.profile"
        case .profile: return "person.fill"
        }
    }
}

private struct HomeView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HeaderView()

                HeroBanner()

                LocationCard()

                WeatherRiskCard()

                SOSButton()
                    .padding(.vertical, 8)

                HStack(spacing: 12) {
                    FeatureTile(
                        icon: "person.3.fill",
                        title: "附近互助",
                        subtitle: "就近响应 互帮互助",
                        tint: .xingGreen
                    )

                    FeatureTile(
                        icon: "sparkles",
                        title: "Agent专家系统",
                        subtitle: "AI智能分析 风险预警\n为你的出行保驾护航",
                        tint: .xingBlue
                    )
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 18)
        }
    }
}

private struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("行智")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Text("AI守护户外每一步")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.68))
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(.white.opacity(0.09)))
                    .overlay(Circle().stroke(.white.opacity(0.16), lineWidth: 1))
            }
            .accessibilityLabel("通知")
        }
    }
}

private struct HeroBanner: View {
    var body: some View {
        GlassPanel(cornerRadius: 14) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("AI守护户外每一步")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.xingGreen)

                    Text("实时环境感知 · 智能风险预判")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.72))
                }

                Spacer()

                MiniMountainMark()
                    .frame(width: 96, height: 38)
            }
            .padding(14)
        }
    }
}

private struct LocationCard: View {
    var body: some View {
        GlassPanel(cornerRadius: 16) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.xingGreen)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("当前位置")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)

                        Spacer()

                        Text("信号良好")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.xingGreen)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.xingGreen.opacity(0.16)))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("四川省阿坝藏族羌族自治州")
                        Text("四姑娘山镇 · 海拔 3,250 米")
                        Text("31.0621°N, 102.8858°E")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.72))
                }

                RadarBadge()
                    .frame(width: 54, height: 54)
            }
            .padding(16)
        }
    }
}

private struct WeatherRiskCard: View {
    var body: some View {
        GlassPanel(cornerRadius: 16) {
            HStack(spacing: 14) {
                HStack(spacing: 10) {
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 30))
                        .symbolRenderingMode(.multicolor)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("12°C")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)

                        Text("多云转晴")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.62))
                    }
                }

                Divider()
                    .background(.white.opacity(0.2))

                VStack(alignment: .leading, spacing: 4) {
                    Text("风险提醒")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)

                    Text("中等风险")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.xingOrange)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.xingOrange)

                    Image(systemName: "exclamationmark")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(.white)
                }
                .frame(width: 46, height: 46)
            }
            .padding(14)
        }
    }
}

private struct SOSButton: View {
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.xingOrange.opacity(0.65), .xingOrange.opacity(0.18), .clear],
                            center: .center,
                            startRadius: 44,
                            endRadius: 132
                        )
                    )
                    .frame(width: 264, height: 264)

                ForEach(0..<3) { index in
                    Circle()
                        .stroke(.xingOrange.opacity(0.28 - Double(index) * 0.06), lineWidth: 1)
                        .frame(width: CGFloat(152 + index * 38), height: CGFloat(152 + index * 38))
                }

                Button {
                } label: {
                    VStack(spacing: 6) {
                        Text("SOS")
                            .font(.system(size: 46, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)

                        Text("一键求助")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 152, height: 152)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.45, blue: 0.18), Color(red: 0.78, green: 0.13, blue: 0.08)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .overlay(Circle().stroke(.white.opacity(0.88), lineWidth: 4))
                    .shadow(color: .xingOrange.opacity(0.8), radius: 28, x: 0, y: 0)
                }
                .accessibilityLabel("SOS 一键求助")
            }
            .frame(maxWidth: .infinity)

            Text("遇到危险，立即获得帮助")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.62))
        }
    }
}

private struct FeatureTile: View {
    let icon: String
    let title: String
    let subtitle: String
    let tint: Color

    var body: some View {
        GlassPanel(cornerRadius: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(tint)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
            .padding(16)
        }
    }
}

private struct MutualAidView: View {
    private let partners = [
        ("正在前往", "890m"),
        ("正在前往", "1.2km"),
        ("可响应", "1.6km"),
        ("可响应", "2.1km")
    ]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("附近互助")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()

                Text("4人在线")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.xingGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.xingGreen.opacity(0.16)))
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)

            GlassPanel(cornerRadius: 24) {
                ZStack {
                    MapGrid()

                    RadarRings(tint: .xingBlue)
                        .frame(width: 240, height: 240)

                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.xingBlue)
                        .shadow(color: .xingBlue.opacity(0.9), radius: 14)

                    AidPin(x: -84, y: -60, distance: "890m")
                    AidPin(x: 76, y: -76, distance: "1.6km")
                    AidPin(x: -66, y: 74, distance: "1.6km")
                    AidPin(x: 92, y: 78, distance: "2.1km")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(.horizontal, 18)

            GlassPanel(cornerRadius: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("附近伙伴 (4)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)

                    ForEach(Array(partners.enumerated()), id: \.offset) { _, partner in
                        HStack(spacing: 10) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.xingGreen)

                            Text(partner.0)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.84))

                            Spacer()

                            Text(partner.1)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white.opacity(0.68))

                            Image(systemName: "chevron.right.circle.fill")
                                .foregroundStyle(.xingGreen)
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.06)))
                    }

                    Button {
                    } label: {
                        Text("立即响应")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(LinearGradient(colors: [.xingGreen, Color(red: 0.12, green: 0.52, blue: 0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    }
                }
                .padding(14)
            }
            .padding(.horizontal, 18)

            Spacer(minLength: 0)
        }
    }
}

private struct AgentView: View {
    private let actions: [(String, String, String, Color)] = [
        ("风险评估", "AI实时分析环境与身体风险", "shield.lefthalf.filled", .xingBlue),
        ("急救建议", "AI生成应对建议与处置步骤", "cross.case.fill", .xingGreen),
        ("路线预警", "AI识别道路服务与天气变化", "exclamationmark.triangle.fill", .xingOrange),
        ("工具调用", "AI调用地图、天气等工具", "wrench.and.screwdriver.fill", .xingBlue),
        ("建议步骤", "为你规划最佳行动步骤", "checklist.checked", .xingGreen)
    ]

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Text("Agent专家系统")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    GlassPanel(cornerRadius: 18) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(.xingBlue.opacity(0.24))
                                    .frame(width: 58, height: 58)

                                Image(systemName: "sparkles")
                                    .font(.system(size: 26, weight: .black))
                                    .foregroundStyle(.white)
                                    .padding(12)
                                    .background(Circle().fill(.xingBlue))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("你好，我是行智AI Agent")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)

                                Text("我可以为你分析风险并提供专业建议，保障你的安全。")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.66))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(16)
                    }

                    ForEach(actions, id: \.0) { item in
                        AgentActionRow(title: item.0, subtitle: item.1, icon: item.2, tint: item.3)
                    }

                    GlassPanel(cornerRadius: 22) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("AI智能决策")
                                .font(.system(size: 24, weight: .heavy, design: .rounded))
                                .foregroundStyle(.xingBlue)

                            Text("多维分析 × 实时推理\n为你的安全出行护航")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white.opacity(0.72))

                            NetworkOrb()
                                .frame(height: 170)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 20)
            }

            HStack(spacing: 10) {
                Text("需要我帮你做什么？")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.42))

                Spacer()

                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white.opacity(0.72))
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(RoundedRectangle(cornerRadius: 18).fill(Color.xingCard.opacity(0.92)))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.1), lineWidth: 1))
            .padding(.horizontal, 18)
        }
    }
}

private struct AgentActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color

    var body: some View {
        GlassPanel(cornerRadius: 15) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: 34, height: 34)
                    .background(RoundedRectangle(cornerRadius: 10).fill(tint.opacity(0.16)))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.58))
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                }

                Spacer()

                Image(systemName: "chevron.right.circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.56))
            }
            .padding(12)
        }
    }
}

private struct MessageView: View {
    var body: some View {
        PlaceholderScreen(
            title: "消息",
            icon: "message.fill",
            message: "附近响应、风险提醒和Agent建议会汇总在这里。"
        )
    }
}

private struct ProfileView: View {
    var body: some View {
        PlaceholderScreen(
            title: "我的",
            icon: "person.fill",
            message: "管理出行档案、紧急联系人和离线安全配置。"
        )
    }
}

private struct PlaceholderScreen: View {
    let title: String
    let icon: String
    let message: String

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 58, weight: .bold))
                .foregroundStyle(.xingBlue)

            Text(title)
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            Text(message)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.66))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 38)

            Spacer()
        }
    }
}

private struct BottomNavigation: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .bold))

                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(selectedTab == tab ? Color.xingGreen : Color.white.opacity(0.42))
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                }
                .accessibilityLabel(tab.rawValue)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial.opacity(0.86))
        .overlay(Rectangle().fill(.white.opacity(0.08)).frame(height: 1), alignment: .top)
    }
}

private struct GlassPanel<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content

    init(cornerRadius: CGFloat, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.xingCard.opacity(0.72))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.26), radius: 18, x: 0, y: 10)
    }
}

private struct MountainBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.07, blue: 0.12),
                    Color(red: 0.05, green: 0.17, blue: 0.24),
                    Color(red: 0.18, green: 0.31, blue: 0.37)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            GeometryReader { proxy in
                let size = proxy.size

                Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height * 0.62))
                    path.addLine(to: CGPoint(x: size.width * 0.22, y: size.height * 0.46))
                    path.addLine(to: CGPoint(x: size.width * 0.38, y: size.height * 0.58))
                    path.addLine(to: CGPoint(x: size.width * 0.57, y: size.height * 0.36))
                    path.addLine(to: CGPoint(x: size.width * 0.78, y: size.height * 0.61))
                    path.addLine(to: CGPoint(x: size.width, y: size.height * 0.43))
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                    path.closeSubpath()
                }
                .fill(LinearGradient(colors: [Color.white.opacity(0.24), Color.black.opacity(0.36)], startPoint: .top, endPoint: .bottom))

                Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height * 0.78))
                    path.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.68))
                    path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.76))
                    path.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.62))
                    path.addLine(to: CGPoint(x: size.width, y: size.height * 0.72))
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                    path.closeSubpath()
                }
                .fill(LinearGradient(colors: [Color(red: 0.06, green: 0.15, blue: 0.13), Color.black.opacity(0.72)], startPoint: .top, endPoint: .bottom))

                ContourLines()
                    .stroke(.white.opacity(0.12), lineWidth: 1)

                NetworkPattern()
                    .opacity(0.72)
            }

            LinearGradient(colors: [.black.opacity(0.12), .black.opacity(0.56)], startPoint: .top, endPoint: .bottom)
        }
    }
}

private struct ContourLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        for index in 0..<8 {
            let inset = CGFloat(index) * 32
            let y = rect.minY + CGFloat(index) * 58
            path.move(to: CGPoint(x: rect.minX - 40 + inset, y: y))
            path.addCurve(
                to: CGPoint(x: rect.maxX + 80, y: y + 34),
                control1: CGPoint(x: rect.width * 0.26, y: y - 70),
                control2: CGPoint(x: rect.width * 0.62, y: y + 108)
            )
        }

        return path
    }
}

private struct NetworkPattern: View {
    private let points = [
        CGPoint(x: 0.72, y: 0.12), CGPoint(x: 0.84, y: 0.08), CGPoint(x: 0.92, y: 0.16),
        CGPoint(x: 0.78, y: 0.22), CGPoint(x: 0.88, y: 0.28), CGPoint(x: 0.96, y: 0.24),
        CGPoint(x: 0.1, y: 0.66), CGPoint(x: 0.18, y: 0.74), CGPoint(x: 0.04, y: 0.82)
    ]

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                var path = Path()
                for index in points.indices {
                    let start = CGPoint(x: points[index].x * size.width, y: points[index].y * size.height)
                    for next in (index + 1)..<min(points.count, index + 3) {
                        let end = CGPoint(x: points[next].x * size.width, y: points[next].y * size.height)
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                }
                context.stroke(path, with: .color(.xingBlue.opacity(0.28)), lineWidth: 1)

                for point in points {
                    let center = CGPoint(x: point.x * size.width, y: point.y * size.height)
                    context.fill(Path(ellipseIn: CGRect(x: center.x - 3, y: center.y - 3, width: 6, height: 6)), with: .color(.white.opacity(0.85)))
                    context.stroke(Path(ellipseIn: CGRect(x: center.x - 12, y: center.y - 12, width: 24, height: 24)), with: .color(.white.opacity(0.32)), lineWidth: 1)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

private struct MiniMountainMark: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.xingBlue.opacity(0.52), .xingGreen.opacity(0.28)], startPoint: .top, endPoint: .bottom)

            Path { path in
                path.move(to: CGPoint(x: 0, y: 38))
                path.addLine(to: CGPoint(x: 22, y: 18))
                path.addLine(to: CGPoint(x: 38, y: 30))
                path.addLine(to: CGPoint(x: 58, y: 8))
                path.addLine(to: CGPoint(x: 96, y: 38))
                path.closeSubpath()
            }
            .fill(.white.opacity(0.72))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct RadarBadge: View {
    var body: some View {
        ZStack {
            Circle().fill(Color.xingGreen.opacity(0.14))
            RadarRings(tint: .xingGreen)
            Circle().fill(Color.xingGreen).frame(width: 9, height: 9)
            Rectangle().fill(Color.xingGreen.opacity(0.82)).frame(width: 2, height: 42)
            Rectangle().fill(Color.xingGreen.opacity(0.82)).frame(width: 42, height: 2)
        }
    }
}

private struct RadarRings: View {
    let tint: Color

    var body: some View {
        ZStack {
            ForEach(1..<5) { index in
                Circle()
                    .stroke(tint.opacity(0.28), lineWidth: 1)
                    .scaleEffect(CGFloat(index) / 4)
            }

            Circle()
                .trim(from: 0, to: 0.18)
                .stroke(tint.opacity(0.7), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .rotationEffect(.degrees(35))
        }
    }
}

private struct AidPin: View {
    let x: CGFloat
    let y: CGFloat
    let distance: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.xingGreen)
                .shadow(color: .xingGreen.opacity(0.75), radius: 10)

            Text(distance)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
        }
        .offset(x: x, y: y)
    }
}

private struct MapGrid: View {
    var body: some View {
        ZStack {
            Color(red: 0.03, green: 0.12, blue: 0.18)

            Canvas { context, size in
                var grid = Path()
                for x in stride(from: 0, through: size.width, by: 24) {
                    grid.move(to: CGPoint(x: x, y: 0))
                    grid.addLine(to: CGPoint(x: x, y: size.height))
                }
                for y in stride(from: 0, through: size.height, by: 24) {
                    grid.move(to: CGPoint(x: 0, y: y))
                    grid.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(grid, with: .color(.white.opacity(0.045)), lineWidth: 1)

                var roads = Path()
                roads.move(to: CGPoint(x: 20, y: size.height * 0.7))
                roads.addCurve(
                    to: CGPoint(x: size.width - 10, y: size.height * 0.28),
                    control1: CGPoint(x: size.width * 0.32, y: size.height * 0.54),
                    control2: CGPoint(x: size.width * 0.64, y: size.height * 0.82)
                )
                roads.move(to: CGPoint(x: size.width * 0.18, y: 10))
                roads.addCurve(
                    to: CGPoint(x: size.width * 0.74, y: size.height - 20),
                    control1: CGPoint(x: size.width * 0.28, y: size.height * 0.28),
                    control2: CGPoint(x: size.width * 0.88, y: size.height * 0.42)
                )
                context.stroke(roads, with: .color(.xingBlue.opacity(0.22)), lineWidth: 2)
            }
        }
    }
}

private struct NetworkOrb: View {
    private let nodes = [
        CGPoint(x: 0.5, y: 0.16), CGPoint(x: 0.24, y: 0.32), CGPoint(x: 0.72, y: 0.34),
        CGPoint(x: 0.16, y: 0.62), CGPoint(x: 0.46, y: 0.52), CGPoint(x: 0.82, y: 0.64),
        CGPoint(x: 0.32, y: 0.82), CGPoint(x: 0.64, y: 0.84)
    ]

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.42
            context.stroke(Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)), with: .color(.xingBlue.opacity(0.32)), lineWidth: 1)

            var lines = Path()
            for index in nodes.indices {
                let start = CGPoint(x: nodes[index].x * size.width, y: nodes[index].y * size.height)
                for next in (index + 1)..<nodes.count where (index + next).isMultiple(of: 2) {
                    let end = CGPoint(x: nodes[next].x * size.width, y: nodes[next].y * size.height)
                    lines.move(to: start)
                    lines.addLine(to: end)
                }
            }
            context.stroke(lines, with: .color(.xingBlue.opacity(0.44)), lineWidth: 1)

            for node in nodes {
                let point = CGPoint(x: node.x * size.width, y: node.y * size.height)
                context.fill(Path(ellipseIn: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)), with: .color(.white))
                context.fill(Path(ellipseIn: CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4)), with: .color(.xingBlue))
            }
        }
        .background(
            RadialGradient(colors: [.xingBlue.opacity(0.22), .clear], center: .center, startRadius: 20, endRadius: 120)
        )
    }
}

private extension Color {
    static let xingGreen = Color(red: 0.43, green: 0.86, blue: 0.46)
    static let xingBlue = Color(red: 0.24, green: 0.65, blue: 1.0)
    static let xingOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let xingCard = Color(red: 0.03, green: 0.13, blue: 0.2)
}

#Preview {
    ContentView()
}
