# SIGMA - Security Information Gathering and Monitoring Analytics

**SIGMA** is a powerful PowerShell script that combines Security Information Gathering and Monitoring Analytics into one automated tool. It helps system administrators and IT professionals gather crucial information, monitor services, validate configurations, and test network connectivity—all while providing some light humor through random Ukrainian jokes.

This script is designed to help automate key tasks related to system security, network monitoring, and file validation, making it a great asset for both security professionals and developers.

---

## Key Features

### 1. Service Status Monitoring
SIGMA helps you `monitor the status` of specific services running on your system. It ensures that critical services are active and running as expected.
  
**Example:**
```./sigma.ps1 -ServiceName "wuauserv" -ExpectedStatus "Running"```
This will verify whether the Windows Update service is running, ensuring that your system is up-to-date with the latest patches.

**Explanation:**
Service status monitoring is important for system health. By regularly checking if essential services are running, administrators can quickly detect and fix issues that may lead to security vulnerabilities or system instability.

### 2. File Existence Validation
**SIGMA** allows you to `validate the existence of files` or directories that are critical to the system's configuration, operation, or security. It ensures that the necessary files are present and not missing or altered.

**Example:**
```./sigma.ps1 -Path "C:\Windows\System32"```
This command will confirm that the System32 directory, a crucial part of Windows, exists. If it’s missing, it could indicate a system problem or breach.

**Explanation:**
File existence validation is key for maintaining system integrity. Missing or tampered files can be a sign of malicious activity, misconfigurations, or incomplete installations. Automating this check ensures the system remains in a secure state.

### 3. Network Connectivity Testing
`Network connectivity` testing ensures that your system can properly connect to other devices on your local network and external resources like websites. This feature is essential for troubleshooting network issues and ensuring proper communication within your network infrastructure.

**Example:**
``./sigma.ps1 -Network``
This will verify if the system can connect to the local network, checking for potential issues with your internal network infrastructure.

**Explanation:**
Network connectivity is crucial for a system to function correctly, especially in environments that rely on remote servers, shared resources, or internet access. Automated tests help ensure that all network connections are active and stable, which is essential for security and performance.

### 4. MonoBank API
One of the unique features of **SIGMA** is its integration with *Monobank’s API* to retrieve information about the client’s accounts and balance. **Monobank** is a popular Ukrainian digital bank, known for offering quick, convenient financial services through its mobile app.

The script connects to *Monobank's API*, pulls client data, and provides details such as account balances, credit limits, and even savings jars. This integration is useful for financial analysts, developers, and anyone who wants to programmatically manage their **Monobank** data directly within the script.

**How it Works:**

The script retrieves personal information about the client (name and client ID) using an API token.
It fetches details about all accounts, including the balance, credit limit, and currency codes.
It also provides information about "jars" (a feature that allows users to set up savings goals) and displays the jar balance and goal amount.
The Monobank integration ensures that your financial data is accessed securely, offering a seamless connection to the service.

**Example:**
```./sigma.ps1```

- **To use the Monobank integration, you need to paste your personal X-Token into the $apiToken variable in the script.**

---

## Installation

### Requirements:

1. PowerShell 7.0+ (Pwsh)

2. Administrative privileges on the system
3. Internet access for fetching Monobank data and testing external network connections
### Steps:

- **Clone or download the repository:**
```git clone https://example.com/SIGMA.git```
- **Navigate to the directory containing sigma.ps1.**

### Usage

To run the script, use the following command format:
``./sigma.ps1 -ServiceName <ServiceName> -Path <Path> -Network``

**Where:**
``<ServiceName>`` is the name of the service to monitor (e.g., wuauserv for Windows Update).
``<Path>`` is the path to a file or directory you want to check for existence.
-Network enables network connectivity testing to ensure the system can access local and remote resources.
Example:
``./sigma.ps1 -ServiceName "wuauserv" -Path "C:\Windows\System32" -Network``

**This will:**
- Check if the Windows Update service is running.
- Confirm that the System32 directory exists.
- Test network connectivity to the local network.
- Contributing

---
## License

**This project is licensed under the GPL-3.0 License - see the LICENSE file for details.**
