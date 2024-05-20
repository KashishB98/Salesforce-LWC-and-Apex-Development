public interface DataAccess {
    List<SObject> getData();
    void updateData(List<SObject> records);
}