import ElementaryUI

struct TodoItem {
    var title: String
    var description: String
    var deadline: String
}

@View
struct ContentView {
    @State var count: Int = 0
    @State var items: [TodoItem] = []

    var body: some View {
        div(.class("max-w-3xl mx-auto p-8")) {
            div(.class("mb-8")) {
                h1(.class("text-4xl font-bold text-gray-900 mb-2")) {
                    "✨ My Todo List"
                }

                p(.class("text-gray-600 mb-6")) {
                    "Stay organized and get things done"
                }
            }

            button(.class("bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold px-6 py-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 mb-8 w-full")) {
                "➕ Add New Todo"
            }
            .onClick {
                createTodoItem()
            }

            div(.class("space-y-4")) {
                ForEach(items.enumerated(), key: \.offset) { item in
                    TodoItemView(item: item.element)
                }
            }
        }
        .animateContainerLayout()
        .animation(.smooth, value: count)
    }

    func createTodoItem() {
        items.append(
            TodoItem(
                title: "Title",
                description: "Description",
                deadline: "2026-01-15"
            )
        )
    }
}

@View
struct TodoItemView {
    let item: TodoItem

    var body: some View {
        div(.class("bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border-l-4 border-blue-500")) {
            div(.class("flex items-center gap-3 mb-3")) {
                span(.class("text-2xl")) {
                    "📌"
                }
                h3(.class("text-xl font-bold text-gray-900")) {
                    item.title
                }
            }

            p(.class("text-gray-600 text-base leading-relaxed mb-4 ml-11")) {
                item.description
            }

            div(.class("flex items-center gap-2 ml-11")) {
                span(.class("text-sm")) {
                    "🗓️"
                }
                span(.class("text-sm font-medium text-blue-600")) {
                    item.deadline
                }
            }
        }
    }
}
