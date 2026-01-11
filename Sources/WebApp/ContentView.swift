import Foundation
import ElementaryUI

struct TodoItem {
    var title: String
    var description: String
    var deadline: Date
}

@View
struct ContentView {
    @State var count: Int = 0
    @State var items: [TodoItem] = []

    var body: some View {
        div {
            div {
                h1 { "✨ My Todo List" }
                    .attributes(.class("text-4xl font-bold text-gray-900 mb-2"))

                p { "Stay organized and get things done" }
                    .attributes(.class("text-gray-600 mb-6"))
            }
            .attributes(.class("mb-8"))

            button { "➕ Add New Todo" }
                .attributes(.class("bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold px-6 py-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 mb-8 w-full"))
                .onClick {
                    createTodoItem()
                }

            div {
                ForEach(items.enumerated(), key: \.offset) { item in
                    TodoItemView(item: item.element)
                }
            }
            .attributes(.class("space-y-4"))
        }
        .attributes(.class("max-w-3xl mx-auto p-8"))
        .animateContainerLayout()
        .animation(.smooth, value: count)
    }

    func createTodoItem() {
        let sampleTitles = ["Buy groceries", "Finish project report", "Call dentist", "Review pull request", "Plan weekend trip"]
        let sampleDescriptions = [
            "Get milk, eggs, bread, and fresh vegetables from the store",
            "Complete the quarterly analysis and prepare presentation slides",
            "Schedule annual checkup and cleaning appointment",
            "Review and provide feedback on the new feature implementation",
            "Research destinations and book accommodation"
        ]
        let randomIndex = Int.random(in: 0..<sampleTitles.count)

        items.append(
            TodoItem(
                title: sampleTitles[randomIndex],
                description: sampleDescriptions[randomIndex],
                deadline: Date().addingTimeInterval(Double.random(in: 86400...604800))
            )
        )
    }
}

@View
struct TodoItemView {
    let item: TodoItem

    var body: some View {
        div {
            div {
                div {
                    span { "📌" }
                        .attributes(.class("text-2xl"))
                    h3 { item.title }
                        .attributes(.class("text-xl font-bold text-gray-900"))
                }
                .attributes(.class("flex items-center gap-3 mb-3"))

                p { item.description }
                    .attributes(.class("text-gray-600 text-base leading-relaxed mb-4 ml-11"))

                div {
                    span { "🗓️" }
                        .attributes(.class("text-sm"))
                    span { item.deadline.formatted() }
                        .attributes(.class("text-sm font-medium text-blue-600"))
                }
                .attributes(.class("flex items-center gap-2 ml-11"))
            }
            .attributes(.class("bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border-l-4 border-blue-500"))
        }
    }
}
