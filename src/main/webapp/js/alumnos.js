document.addEventListener("DOMContentLoaded", () => {
    const studentItems = document.querySelectorAll(".student-list-item");

    const studentData = {
        1: {
            initials: "CG",
            name: "Carla Gómez",
            status: "Activa",
            birthDate: "12/05/2009",
            phone: "999 123 4567",
            curp: "GOGC090512MQRMLRA3",
            activitiesCount: "3",
            address: "Calle 24 #123, Col. Centro, Chetumal, Quintana Roo, C.P. 77000",
            monthAttendance: "17"
        },
        2: {
            initials: "JP",
            name: "José Pérez",
            status: "Activo",
            birthDate: "21/08/2009",
            phone: "999 234 5678",
            curp: "PEJJ090821HQRRSL02",
            activitiesCount: "2",
            address: "Av. Reforma #45, Col. Las Palmas, Chetumal, Quintana Roo, C.P. 77010",
            monthAttendance: "13"
        },
        3: {
            initials: "AR",
            name: "Andrea Ruiz",
            status: "Activa",
            birthDate: "03/02/2008",
            phone: "999 345 6789",
            curp: "RUIA080203MQRNND04",
            activitiesCount: "3",
            address: "Calle 8 #19, Col. Del Bosque, Chetumal, Quintana Roo, C.P. 77013",
            monthAttendance: "15"
        },
        4: {
            initials: "MC",
            name: "Mateo Chan",
            status: "Activo",
            birthDate: "17/11/2010",
            phone: "999 456 7890",
            curp: "CHAM101117HQRNTT07",
            activitiesCount: "1",
            address: "Calle 10 #88, Col. Proterritorio, Chetumal, Quintana Roo, C.P. 77017",
            monthAttendance: "6"
        },
        5: {
            initials: "SC",
            name: "Sofía Castillo",
            status: "Activa",
            birthDate: "29/06/2009",
            phone: "999 567 8901",
            curp: "CASS090629MQRTRL01",
            activitiesCount: "2",
            address: "Calle 30 #54, Col. Solidaridad, Chetumal, Quintana Roo, C.P. 77020",
            monthAttendance: "11"
        },
        6: {
            initials: "LM",
            name: "Lucía Martínez",
            status: "Inactiva",
            birthDate: "14/04/2008",
            phone: "999 678 9012",
            curp: "MALU080414MQRRCC05",
            activitiesCount: "0",
            address: "Calle 60 #12, Col. Centro, Chetumal, Quintana Roo, C.P. 77000",
            monthAttendance: "0"
        }
    };

    const studentDetailAvatar = document.getElementById("studentDetailAvatar");
    const studentDetailName = document.getElementById("studentDetailName");
    const studentDetailStatus = document.getElementById("studentDetailStatus");
    const studentDetailBirthDate = document.getElementById("studentDetailBirthDate");
    const studentDetailPhone = document.getElementById("studentDetailPhone");
    const studentDetailCurp = document.getElementById("studentDetailCurp");
    const studentDetailActivitiesCount = document.getElementById("studentDetailActivitiesCount");
    const studentDetailAddress = document.getElementById("studentDetailAddress");
    const studentDetailMonthAttendance = document.getElementById("studentDetailMonthAttendance");

    function loadStudent(studentId) {
        const student = studentData[studentId];
        if (!student) return;

        studentDetailAvatar.textContent = student.initials;
        studentDetailName.textContent = student.name;
        studentDetailStatus.textContent = student.status;
        studentDetailBirthDate.textContent = student.birthDate;
        studentDetailPhone.textContent = student.phone;
        studentDetailCurp.textContent = student.curp;
        studentDetailActivitiesCount.textContent = student.activitiesCount;
        studentDetailAddress.textContent = student.address;
        studentDetailMonthAttendance.textContent = student.monthAttendance;

        studentDetailStatus.className = "status-badge " + (student.status.toLowerCase().includes("inact") ? "inactive" : "active");
    }

    studentItems.forEach(item => {
        item.addEventListener("click", () => {
            studentItems.forEach(el => el.classList.remove("selected"));
            item.classList.add("selected");

            const studentId = item.dataset.studentId;
            loadStudent(studentId);
        });
    });
});