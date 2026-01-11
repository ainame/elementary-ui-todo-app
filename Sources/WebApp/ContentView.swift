import ElementaryUI

@View
struct ContentView {
    let viewModel = TodoViewModel()

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
                viewModel.onAddNew()
            }

            div(.class("space-y-4")) {
                ForEach(viewModel.items.enumerated(), key: { $0.element.id }) { item in
                    TodoItemView(
                        item: item.element,
                        onDelete: { viewModel.onDelete(at: item.offset) }
                    )
                }
            }
        }
        .animateContainerLayout()
        .animation(.smooth, value: viewModel.items.count)
    }
}
