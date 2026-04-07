import FirebaseFirestore

enum DefaultResponse<T> {
    case success(data: T)
    case failure(Error: String)
}

class FirestoreDB {
    public func encodeData<T: Encodable>(_ data: T) throws -> [String: Any] {
        return try Firestore.Encoder().encode(data)
    }
    
    public func generateID() -> String {
        return db.collection("Todos").document().documentID
    }
    
    public func getDocument<T: Decodable>(collection collectionName: String, id: String) async -> DefaultResponse<T> {
        do {
            let snapshot = db.collection(collectionName).document(id)
            let data = try await snapshot.getDocument(as: T.self)
            return .success(data: data)
        } catch {
            return .failure(Error: "Erro on getting data.")
        }
    }
    
    public func getDocuments<T: Decodable>(collection collectionName: String) async -> DefaultResponse<[T]> {
        var data: [T] = []
        do {
            let snapshot = try await db.collection(collectionName).getDocuments()
            
            for document in snapshot.documents {
                if let document = try? document.data(as: T.self) {
                    data.append(document)
                }
            }
            
            return .success(data: data)
        } catch {
            return .failure(Error: "Error on getting data.")
        }
    }
    
    public func addDocument<T: Encodable>(
        collection collectionName: String,
        _ data: T
    ) async -> DefaultResponse<String> {
        do {
            let encodedData = try self.encodeData(data)
            let ref = try await db.collection(collectionName).addDocument(data: encodedData)
            return .success(data: ref.documentID)
        } catch {
            return .failure(Error: error.localizedDescription)
        }
    }
    
    public func addEmptyDocument(collection collectionName: String) async -> DefaultResponse<String> {
        do {
            let ref = try await db.collection(collectionName).addDocument(data: [:])
            return .success(data: ref.documentID)
        } catch {
            return .failure(Error: "Error on adding empty document.")
        }
    }
    
    public func updateDocument<T: Encodable>(collection collectionName:String, _ data: T, id: String) async -> DefaultResponse<String> {
        do {
            let ref = db.collection(collectionName).document(id)
            try ref.setData(from: data, merge: true)
            
            return .success(data: "Updated successfully.")
        } catch {
            return .failure(Error: "Error on updating data.")
        }
    }
    
    public func deleteDocument(collection collectionName: String, id: String) async -> DefaultResponse<String> {
        do {
            let ref = db.collection(collectionName).document(id)
            try await ref.delete()
            
            return .success(data: "\(id) deleted successfully.")
        } catch {
            return .failure(Error: "Error on deleting data.")
        }
    }
}
