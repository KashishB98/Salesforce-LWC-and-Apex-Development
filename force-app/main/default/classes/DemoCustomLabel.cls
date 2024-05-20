public class DemoCustomLabel {
    public static void fetchCustomLabel() {
        
        // Approach 1
        String s = System.label.Test_Custom_Label;
        System.debug('custom label with approach 1 - '+s);
        
        // Approach 2
        String textValue = System.Label.get('','Test_Custom_Label','');
        System.debug('Custom Label with approach 2 - '+textValue);
        
        // With translation in german
        String textValueinGerman = System.Label.get('','Test_Custom_Label','de');
        System.debug('Custom Label in german - '+textValueinGerman);
    }
}