package org.example.studentxmlapp.Services;

import org.example.studentxmlapp.Model.StudentData;
import org.springframework.stereotype.Service;
import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class StudentService {

    private static final String XML_FILE = "src/main/java/org/example/studentxmlapp/Model/students.xml";
    private Document doc;

    public StudentService() {
        try {
            loadOrCreateXMLDocument();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadOrCreateXMLDocument() throws Exception {
        File xmlFile = new File(XML_FILE);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        if (xmlFile.exists()) {
            doc = builder.parse(xmlFile);
        } else {
            doc = builder.newDocument();
            Element root = doc.createElement("University");
            doc.appendChild(root);
            saveXMLDocument();
        }
    }

    public String addStudent(StudentData student) {
        if (!isValidStudent(student)) return "Invalid student data.";
        if (getStudentById(student.getId()) != null) return "Student ID already exists.";

        Element studentElement = doc.createElement("Student");
        studentElement.setAttribute("ID", student.getId());

        createAndAppendElement(doc, studentElement, "FirstName", student.getFirstName());
        createAndAppendElement(doc, studentElement, "LastName", student.getLastName());
        createAndAppendElement(doc, studentElement, "Gender", student.getGender());
        createAndAppendElement(doc, studentElement, "GPA", student.getGpa());
        createAndAppendElement(doc, studentElement, "Level", student.getLevel());
        createAndAppendElement(doc, studentElement, "Address", student.getAddress());

        doc.getDocumentElement().appendChild(studentElement);
        saveXMLDocument();
        return "Student added successfully.";
    }

    public String updateStudent(String id, StudentData newDetails) {
        Element student = getStudentById(id);
        if (student == null) return "Student not found.";

        if (newDetails.getFirstName() != null) student.getElementsByTagName("FirstName").item(0).setTextContent(newDetails.getFirstName());
        if (newDetails.getLastName() != null) student.getElementsByTagName("LastName").item(0).setTextContent(newDetails.getLastName());
        if (newDetails.getGender() != null) student.getElementsByTagName("Gender").item(0).setTextContent(newDetails.getGender());
        if (newDetails.getGpa() != null) student.getElementsByTagName("GPA").item(0).setTextContent(newDetails.getGpa());
        if (newDetails.getLevel() != null) student.getElementsByTagName("Level").item(0).setTextContent(newDetails.getLevel());
        if (newDetails.getAddress() != null) student.getElementsByTagName("Address").item(0).setTextContent(newDetails.getAddress());

        saveXMLDocument();
        return "Student updated successfully.";
    }

    public List<StudentData> searchStudentsByMultiAttributes(Map<String, String> criteria) {
        NodeList students = doc.getElementsByTagName("Student");
        List<StudentData> results = new ArrayList<>();
        for (int i = 0; i < students.getLength(); i++) {
            Element student = (Element) students.item(i);
            if (matchesCriteria(student, criteria)) {
                results.add(buildStudentDataFromElement(student));
            }
        }
        return results;
    }

    public List<StudentData> searchStudentsByASearchKey(String searchKey) {
        NodeList students = doc.getElementsByTagName("Student");
        List<StudentData> results = new ArrayList<>();
        for (int i = 0; i < students.getLength(); i++) {
            Element student = (Element) students.item(i);

            // Check all attributes and elements for a match
            if (student.getAttribute("ID").equalsIgnoreCase(searchKey) ||
                    student.getElementsByTagName("FirstName").item(0).getTextContent().equalsIgnoreCase(searchKey) ||
                    student.getElementsByTagName("LastName").item(0).getTextContent().equalsIgnoreCase(searchKey) ||
                    student.getElementsByTagName("Gender").item(0).getTextContent().equalsIgnoreCase(searchKey) ||
                    student.getElementsByTagName("GPA").item(0).getTextContent().equals(searchKey) ||
                    student.getElementsByTagName("Level").item(0).getTextContent().equalsIgnoreCase(searchKey) ||
                    student.getElementsByTagName("Address").item(0).getTextContent().equalsIgnoreCase(searchKey)) {

                results.add(buildStudentDataFromElement(student));
            }
        }
        return results;
    }


    public boolean deleteStudent(String studentID) {
        NodeList students = doc.getElementsByTagName("Student");
        for (int i = 0; i < students.getLength(); i++) {
            Element student = (Element) students.item(i);
            if (student.getAttribute("ID").equals(studentID)) {
                student.getParentNode().removeChild(student);
                saveXMLDocument();
                return true;
            }
        }
        return false;
    }

    public List<StudentData> sortStudents(String attribute, boolean ascending) {
        NodeList students = doc.getElementsByTagName("Student");
        List<StudentData> studentList = new ArrayList<>();
        for (int i = 0; i < students.getLength(); i++) {
            studentList.add(buildStudentDataFromElement((Element) students.item(i)));
        }

        Comparator<StudentData> comparator = Comparator.comparing(
                s -> getAttributeValue(s, attribute).toLowerCase()
        );
        if (!ascending) comparator = comparator.reversed();
        studentList.sort(comparator);


        saveSortedXML(studentList);
        return studentList;
    }

    private boolean isValidStudent(StudentData student) {
        return student.getId() != null && !student.getId().isEmpty()
                && student.getFirstName() != null && student.getFirstName().matches("[a-zA-Z]+")
                && student.getLastName() != null && student.getLastName().matches("[a-zA-Z]+")
                && student.getAddress() != null && student.getAddress().matches("[a-zA-Z]+")
                && student.getGpa() != null && Double.parseDouble(student.getGpa()) >= 0 && Double.parseDouble(student.getGpa()) <= 4;
    }

    private boolean matchesCriteria(Element student, Map<String, String> criteria) {
        for (Map.Entry<String, String> entry : criteria.entrySet()) {
            String field = entry.getKey();
            String value = entry.getValue();
            NodeList elements = student.getElementsByTagName(field);
            if (elements.getLength() == 0 || elements.item(0) == null ||
                    !elements.item(0).getTextContent().equalsIgnoreCase(value)) {
                return false;
            }
        }
        return true;
    }

    private String getAttributeValue(StudentData student, String attribute) {
        switch (attribute.toLowerCase()) {
            case "id": return student.getId();
            case "firstname": return student.getFirstName();
            case "lastname": return student.getLastName();
            case "gender": return student.getGender();
            case "gpa": return student.getGpa();
            case "level": return student.getLevel();
            case "address": return student.getAddress();
            default: return "";
        }
    }

    private Element getStudentById(String id) {
        NodeList students = doc.getElementsByTagName("Student");
        for (int i = 0; i < students.getLength(); i++) {
            Element student = (Element) students.item(i);
            if (student.getAttribute("ID").equals(id)) {
                return student;
            }
        }
        return null;
    }

    private StudentData buildStudentDataFromElement(Element student) {
        StudentData data = new StudentData();
        data.setId(student.getAttribute("ID"));
        data.setFirstName(student.getElementsByTagName("FirstName").item(0).getTextContent());
        data.setLastName(student.getElementsByTagName("LastName").item(0).getTextContent());
        data.setGender(student.getElementsByTagName("Gender").item(0).getTextContent());
        data.setGpa(student.getElementsByTagName("GPA").item(0).getTextContent());
        data.setLevel(student.getElementsByTagName("Level").item(0).getTextContent());
        data.setAddress(student.getElementsByTagName("Address").item(0).getTextContent());
        return data;
    }

    private void createAndAppendElement(Document doc, Element parent, String tagName, String value) {
        Element element = doc.createElement(tagName);
        element.appendChild(doc.createTextNode(value));
        parent.appendChild(element);
    }

    private void saveXMLDocument() {
        try {
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(new File(XML_FILE));
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.transform(source, result);
        } catch (TransformerException e) {
            e.printStackTrace();
        }
    }

    private void saveSortedXML(List<StudentData> students) {
        try {
            doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
            Element root = doc.createElement("University");
            doc.appendChild(root);

            for (StudentData student : students) {
                Element studentElement = doc.createElement("Student");
                studentElement.setAttribute("ID", student.getId());
                createAndAppendElement(doc, studentElement, "FirstName", student.getFirstName());
                createAndAppendElement(doc, studentElement, "LastName", student.getLastName());
                createAndAppendElement(doc, studentElement, "Gender", student.getGender());
                createAndAppendElement(doc, studentElement, "GPA", student.getGpa());
                createAndAppendElement(doc, studentElement, "Level", student.getLevel());
                createAndAppendElement(doc, studentElement, "Address", student.getAddress());
                root.appendChild(studentElement);
            }

            saveXMLDocument();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
