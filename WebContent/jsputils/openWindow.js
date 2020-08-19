var OpenWindow
function openHelpWindow(content) {

if (!(OpenWindow!=null)) {
OpenWindow=window.open("", "helpwin","height=300,width=300,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
} else if (OpenWindow.closed) {
OpenWindow=window.open("", "helpwin","height=300,width=300,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
}

OpenWindow.document.write("<HTML>")
OpenWindow.document.write("<HEAD>")
OpenWindow.document.write("<TITLE>Help Info</TITLE>")
OpenWindow.document.write("<BODY BGCOLOR='white'>")
OpenWindow.document.write(content)
OpenWindow.document.write("<p align=center><a href='javascript:window.close()'>Click here to close</a></p>")
OpenWindow.document.write("</body>")
OpenWindow.document.write("</html>")
OpenWindow.document.close()
OpenWindow.focus()
}

function openChildWindow(content) {

if (!(OpenWindow!=null)) {
OpenWindow=window.open("", "childwin","height=300,width=352,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
} else if (OpenWindow.closed) {
OpenWindow=window.open("", "childwin","height=300,width=352,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
}

OpenWindow.document.write("<HTML>")
OpenWindow.document.write("<HEAD>")
OpenWindow.document.write("<TITLE>More Information</TITLE>")
OpenWindow.document.write("<BODY BGCOLOR='lightblue'>")
OpenWindow.document.write(content)
OpenWindow.document.write("<p align=center><a href='javascript:window.close()'>Click here to close</a></p>")
OpenWindow.document.write("</body>")
OpenWindow.document.write("</html>")
OpenWindow.document.close()
OpenWindow.focus()

}

function openChildWindowHTML(file) {
if (!(OpenWindow!=null)) {
OpenWindow=window.open(file, "childwin","height=300,width=352,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
} else if (OpenWindow.closed) {
OpenWindow=window.open(file, "childwin","height=300,width=352,toolbar=no,menubar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes");
} else {
OpenWindow.document.location = file;
}
OpenWindow.focus()
}
