import user_crud_service.database;

 public function main() returns error? {
   check database:testConnection();
 }