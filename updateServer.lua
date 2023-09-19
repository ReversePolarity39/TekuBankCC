-- startup.lua for Main Updating Server

-- Function to download files from GitHub
function downloadFromGithub(filename, url)
    local request = http.get(url)
    if request then
        local content = request.readAll()
        request.close()
        local file = fs.open(filename, "w")
        file.write(content)
        file.close()
        return true
    else
        return false
    end
end

-- Function to create installer disk
function createInstallerDisk()
    print("Creating installer disk...")
    -- Define GitHub URLs for necessary files
    local githubUrls = {
        ["api.lua"] = "https://github.com/your-repo/api.lua",
        ["pullapi.lua"] = "https://github.com/your-repo/pullapi.lua",
        -- Add more files as needed
    }
    -- Download each file and write to disk
    for filename, url in pairs(githubUrls) do
        if downloadFromGithub("/disk/"..filename, url) then
            print(filename.." downloaded successfully.")
        else
            print("Failed to download "..filename)
        end
    end
    print("Installer disk created.")
end

-- Function to perform a global update
function globalUpdate()
    print("Performing global update...")
    local choice = read()
    if choice == "floppy" then
        -- Code to update from floppy disk
    elseif choice == "github" then
        -- Code to update from GitHub
    else
        print("Invalid choice.")
    end
end

-- Main program
while true do
    print("Main Updating Server")
    print("1: Create Installer Disk")
    print("2: Global Update")
    print("Enter your choice:")
    local choice = read()
    if choice == "1" then
        createInstallerDisk()
    elseif choice == "2" then
        globalUpdate()
    else
        print("Invalid choice. Try again.")
    end
end
