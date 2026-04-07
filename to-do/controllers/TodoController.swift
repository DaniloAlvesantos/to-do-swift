struct FullResponse<T> {
    var data: T?
    var isError: Bool
    var message: String
}

class TodoController {
    private var db: FirestoreDB = FirestoreDB()
    private let collectionName: String = "Todos"
    
    public func getToDo(_ id: String) async -> FullResponse<ToDoCollection> {
        let response: DefaultResponse<ToDoCollection> = await self.db.getDocument(collection: self.collectionName, id: id)
        
        switch(response) {
        case .success(let data):
            return FullResponse(data: data, isError: false, message: "")
        case .failure(let error):
            return FullResponse(data: nil, isError: true, message: error)
        }
    }
    
    public func getToDos() async -> FullResponse<[ToDoCollection]> {
        let response: DefaultResponse<[ToDoCollection]> = await self.db.getDocuments(collection: self.collectionName)
        
        switch(response) {
        case .success(let data):
            return FullResponse(data: data, isError: false, message: "")
        case .failure(let error):
            return FullResponse(data: nil, isError: true, message: error)
        }
    }
    
    public func createToDo() -> FullResponse<String> {
        let response = self.db.generateID()
        
        if response.isEmpty {
            return FullResponse(isError: true, message: "ID was not generated")
        } else {
            return FullResponse(data: response, isError: false, message: "")
        }
    }
    
    public func addToDo(_ data: ToDoType) async -> FullResponse<String> {
        let response = await self.db.addDocument(collection: self.collectionName, data)
        
        switch(response) {
        case .success(let data):
            return FullResponse(data: data, isError: false, message: "")
        case .failure(let error):
            return FullResponse(data:"", isError: true, message: error)
        }
    }
    
    public func updateToDo(_ data: ToDoCollection, id: String) async -> FullResponse<String> {
        let response = await self.db.updateDocument(collection: self.collectionName, data, id: id)
        
        switch(response) {
        case .success(let message):
            return FullResponse(data: message, isError: false, message: "")
        case .failure(let error):
            return FullResponse(data: "", isError: true, message: error)
        }
    }
    
    public func deleteToDo(_ id: String) async -> FullResponse<Bool> {
        let response = await self.db.deleteDocument(collection: self.collectionName, id: id)
        
        switch(response) {
        case .success(let data):
            return FullResponse(data: true, isError: false, message: "")
        case .failure(let error):
            return FullResponse(data: false, isError: true, message: error)
        }
    }
}
