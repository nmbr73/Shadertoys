local ui = {
    chosenInstallModeOption = nil,
    windowGeometry       = { 100, 100, 800, 400 },
    targetIsGitRepo = nil,
}

ui.manager    = fu.UIManager
ui.dispatcher = bmd.UIDispatcher(ui.manager)


function ui.selectFusesDialog(params)

  assert(params~=nil)
  assert(params.fuses~=nil)

  local thumbWidth=107 -- 160
  local thumbHeight=60 -- 90

  local win = ui.dispatcher:AddWindow({

    ID = "ShaderInstallMain",
    WindowTitle = params.windowTitle,
    Geometry = { 100, 100, 700, 400 },
    -- Composition = comp,

    ui.manager:VGroup {
      -- ID = "root",

      ui.manager:HGroup {
        Weight = 0,
        ui.logo(),

        ui.manager:HGap(0,1),

        ui.manager:Label{
          ID = "Thumbnail",
          WordWrap = false,
          Weight = 0,
          MinimumSize = {thumbWidth, thumbHeight},
          ReadOnly = true,
          Flat = true,
          Alignment = { AlignHCenter = false, AlignTop = true, },
          Text = '<img src="file:/Users/nmbr73/Projects/Shadertoys/Shaders/Abstract/Crazyness_320x180.png" width="'..thumbWidth..'" height="'..thumbHeight..'" />',
        },

      },


      --https://nmbr73.github.io/Shadertoys/Shaders/Abstract/Crazyness_320x180.png

      -- ui.manager:TabBar {
      -- },

      ui.manager:VGap(5),


      ui.manager:Tree {
        ID = 'Files',
        Weight = 2,
        SortingEnabled=true,
        Events = {  ItemDoubleClicked=true, ItemClicked=true,  },
        MinimumSize = {600, 200},

      },





      -- g_ui:VGap(5),

      -- g_ui:VGroup {
      --     Weight = 0,
      --     g_ui:CheckBox{ID = 'UseShortcutPrefix', Text = "Use prefix not only for Fuse name, but also for its OpIconString",  Checked=false },
      --     g_ui:CheckBox{ID = 'UseShadertoyID',    Text = "Use Shadertoy IDs as Identifiers instead of shortcuts ",            Checked=true  },
      --     g_ui:CheckBox{ID = 'UseCategoryPathes', Text = "Use pathes as categrory for 'Add Tool ...' menu",                   Checked=true  },
      -- },

      ui.manager:VGap(5),

      ui.manager:HGroup{
        Weight = 0,

        ui.manager:Label {
          ID = 'Error',
          Weight = 3.0,
          Alignment = { AlignHCenter = false, AlignVTop = true, },
          WordWrap = false,
        },

        ui.manager:HGap(0,1),
        ui.manager:Button{ ID = "Install",  Text = "Install" },
        ui.manager:Button{ ID = "Cancel",   Text = "Cancel" },
      },

    },
  })


  local itm = win:GetItems()


  function win.On.Install.Clicked(ev)
    win:Hide()
    params.onInstall(params.fuses)
    -- g_chosenInstallModeOption.Procedure(params.ListOfFuses)
  end


  function win.On.Cancel.Clicked(ev)
    win:Hide()
    ui.ExitLoop()
  end


  function win.On.ShaderInstallMain.Close(ev)
    win:Hide()
    ui.ExitLoop()
  end

  function win.On.Files.ItemDoubleClicked(ev)
    local fuse=params.fuses.get_fuse(ev.item.Text[0],ev.item.Text[1])

    if fuse~=nil then
      -- bmd.openurl("https://www.shadertoy.com/view/"..fuse.shadertoy_id)
      bmd.openurl('https://nmbr73.github.io/Shadertoys/Shaders/'..fuse.file_category..'/'..fuse.file_fusename..'.html')
    end
  end

  local defaultInfoText=""

  function win.On.Files.ItemClicked(ev)
    local fuse=params.fuses.get_fuse(ev.item.Text[0],ev.item.Text[1])

    if fuse==nil then return end

    itm.Thumbnail.Text='<img src="file:/Users/nmbr73/Projects/Shadertoys/Shaders/'
      ..fuse.file_category..'/'..fuse.file_fusename..'_320x180.png" width="'..thumbWidth..'" height="'..thumbHeight..'" />'

    itm.Error.Text = fuse.error and '<span style="color:#ff9090; ">'..fuse.error.."</span>" or defaultInfoText
  end


  local hdr = itm.Files:NewItem()
  hdr.Text[0] = 'Category'
  hdr.Text[1] = 'Fuse Name'
  hdr.Text[2] = 'Author'
  hdr.Text[3] = 'Port'
  itm.Files:SetHeaderItem(hdr)
  itm.Files.ColumnCount = 4

  itm.Files.ColumnWidth[0] = 120
  itm.Files.ColumnWidth[1] = 400
  itm.Files.ColumnWidth[2] = 80
  itm.Files.ColumnWidth[3] = 60

  -- g_useShortcutPrefix = itm.UseShortcutPrefix
  -- g_useShadertoyID    = itm.UseShadertoyID
  -- g_useCategoryPathes = itm.UseCategoryPathes

  local numFuses=0

  for i, f in ipairs(params.fuses.list) do

    -- print("add "..f.file_category.."/"..f.file_fusename)
    local newitem = itm.Files:NewItem()
    newitem.Text[0] = f.file_category
    newitem.Text[1] = f.file_fusename
    newitem.Text[2] = f.shadertoy_author
    newitem.Text[3] = (f.error and '🚫 ' or '')..f.dctlfuse_author
    itm.Files:AddTopLevelItem(newitem)

    if f.error==nil then
      numFuses=numFuses+1
    end
  end

  defaultInfoText=numFuses.." valid fuses found"

  -- local entry       = params.ListOfFuses.head -- LIST_OF_FUSES.head
  -- local num_wip = 0

  -- while entry do
  --   if entry.Install then
  --     local newitem = itm.Files:NewItem()
  --     newitem.Text[0] = entry.File
  --     itm.Files:AddTopLevelItem(newitem)
  --   else
  --     num_wip = num_wip +1
  --   end
  --   entry=entry.next
  -- end

  -- itm.NumberOfFusesLabel.Text= (params.ListOfFuses.len - num_wip) .." Fuses to be installed".. (num_wip and " ("..num_wip.." ignored)" or "")

  return win


end





-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function ui.chooseInstallOption(params)

  assert(params.targetIsGitRepo ~= nil)
  -- local targetIsGitRepo=false
  if params==nil then params={} end


  local optionNotImplemented=[[
    <p style="color:#ffffff; ">
      <span style="color:#ff9090; ">This option has not been implemented yet.</span>
      The whole thing is work in progress. And this option is only here as a reminder.
    </p>
  ]]

  local options=
  {
    { -- Mode        = MODE_NONE,
      Label       = "- chose installation mode -",
      Enabled     = false,
      Procedure   = nil,
      Text        = [[
        <p>This script is menat to install the shader fuses, or to create installation scripts to install the shader fuses.
        Use the select box on top to chose an installation mode and to see further details on the respective method.</p>
      ]]
      .."<p>"..(params.targetIsGitRepo and 'Accessing the Git repo' or 'Working on the ZIP').."</p>"
      ,
    },

    { -- Mode        = MODE_LOCALCOPY,
      Label       = "Local Copy",
      Enabled     = not(params.targetIsGitRepo) and params.localCopySelected~=nil,
      Procedure   = params.localCopySelected,
      Text        = [[
        <p>If you have downloaded and extracted(!) the whole repository as a ZIP file, then this mode should help you to
        create a local copy of the fuses in the correct target directory. In this case the script creates the <em>Shadertoys<em>
        subdirectories in your DaVinci Resolve's / Fusion's <em>Fuses</em> directory and copies all the .fuse files and only
        these to that directory.</p>
      ]]..(params.targetIsGitRepo and [[
        <p style="color:#ffffff; ">
          <span style="color:#ff9090; ">This option is not available ...</span>
          It seems that you are managing our Shadertoy Fuses using Git already. That's awesome! Forking and/or cloning us
          on GitHub obviously is the right and more pro way of doing things. Just use a 'git pull' in your 'Shadertoys'
          directory and you are up to date and good to go. Looking forward to your pull requests maybe contributing some
          beatutiful shaderstoys?!!
        </p>
      ]] or "")
      .. (params.localCopySelected==nil and optionNotImplemented or ''),

    },

    {
      Label       = "Refresh Overviews",
      Enabled     = params.targetIsGitRepo and params.refreshOverviewsSelected~=nil,
      Procedure   = params.refreshOverviewsSelected,
      Text        = [[
        <p>This one is to update the markdown files showing overview lists for all the fuses.</p>
      ]]..(not(params.targetIsGitRepo) and [[
        <p style="color:#ffffff; ">
          <span style="color:#ff9090; ">This option is not available ...</span>
          This is meant to refresh the repository's overviews - so it makes only sense to call it on the repsotory itself.
        </p>
      ]] or "")
      .. (params.refreshOverviewsSelected==nil and optionNotImplemented or ''),

    },


    { -- Mode        = MODE_SINGLEINSTALLERS,
      Label       = "Single Installers",
      Enabled     = params.onSingleInstallersSelected~=nil,
      Procedure   = params.onSingleInstallersSelected,
      Text        = [[
        <p>This options generates a separate, fully self contained '<tt>*-Installer.lua</tt>' script for each fuse.
        This allows the fuses to be distributed independently of the repository,
        whilst still providing the convenience of not having to copy the Fuse to the specific pathes manually.
        Just drag and drop such an installer script onto your DaFusion's working area and the script will guide
        you through the installation.</p>
        <p style="color:#ffffff; ">
        Please note that hereby any such installer is overwritten. Just run this option from time to time
        on the repository to make the installers contain the most recent versions of the fuses.
        </p>
      ]]
      .. (params.onSingleInstallersSelected==nil and optionNotImplemented or ''),

    },

    { -- Mode        = MODE_CREATEINSTALLER,
      Label       = "Create Installer",
      Enabled     = params.createInstallerSelected~=nil,
      Procedure   = params.createInstallerSelected,
      Text        = [[
        <p>The 'Create Installer' is to create a single Lua script that can be used to install all the fuses.
        It is intended to be provided in particular as a separate download with no need to copy the ZIP or
        clone the repository.</p>
      ]]
      .. (params.refreshOverviewsSelected==nil and optionNotImplemented or ''),

    },

    { -- Mode        = MODE_PREPARESUGGESTION,
      Label       = "Prepare WSL Suggestion",
      Enabled     = params.prepareSuggestionSelected~=nil,
      Procedure   = params.prepareSuggestionSelected,
      Text        = [[
        <p>Idea is to have the installer create copies of the Fuses without all the prefixes, debug settings,
        additinal files, etc. This to end up with a directory structure that can be used in preparation of a
        suggestion for integration into the WSL Reactor.</p>
      ]]
      .. (params.prepareSuggestionSelected==nil and optionNotImplemented or ''),
    },
  }

  ui.chosenInstallModeOption = options[1]


  local win = ui.dispatcher:AddWindow({

    ID = "ShaderInstallSelect",
    WindowTitle = "Shadertoys Installer - Select Installation mode ...",
    Geometry = ui.windowGeometry,
    -- Composition = comp,

    ui.manager:VGroup {
      -- ID = "root",
      Weight=1,

      ui.logo(),

      ui.manager:VGap(10),

      ui.manager:ComboBox{
        ID = "ModeSelection",
        Text = 'Install Mode Selection',
        Weight = 0,
        Events = { CurrentIndexChanged = true, Activated = true },
        Items = { 'Foo' , 'Bar'},
      },

      ui.manager:VGap(10),

      ui.manager:Label{
        ID = "Description",
        WordWrap = true,
        Weight = 1,
        ReadOnly = true,
        Flat = true,
        Alignment = { AlignHCenter = false, AlignTop = true, },
        Text = ""
      },

      ui.manager:HGroup {
        Weight = 0,
        ui.manager:HGap(0,1),
        ui.manager:Button{ ID = "Continue",   Text = "Continue ..." },
        ui.manager:HGap(5),
        ui.manager:Button{ ID = "Cancel",   Text = "Cancel" },
      },
    },
  })


  local itm=win:GetItems()

  for i, option in ipairs(options) do
    itm.ModeSelection:AddItem(option.Label)
  end


  function win.On.ModeSelection.CurrentIndexChanged(ev)

    local index = itm.ModeSelection.CurrentIndex+1
    local entry = options[index]

    assert(entry ~= nil)

    ui.chosenInstallModeOption=entry
    itm.Continue.Enabled=entry.Enabled
    itm.Description.Text=entry.Text
  end


  function win.On.Continue.Clicked(ev)
    win:Hide()
    -- showInstallMainWindow()
    -- params.NextWindow:Show()
    ui.chosenInstallModeOption.Procedure()
  end


  function win.On.Cancel.Clicked(ev)
    ui.dispatcher:ExitLoop()
    os.exit()
  end


  function win.On.ShaderInstallSelect.Close(ev)
    ui.dispatcher:ExitLoop()
    os.exit()
  end



  win:Show()

end

function ui.RunLoop()
  print("ui Run ...")
  ui.dispatcher:RunLoop()
end

function ui.ExitLoop()
  print(".. ui Exit")
  ui.dispatcher:ExitLoop()
end


function ui.logo()
  return ui.manager:Label{
    ID = "",
    WordWrap = false,
    Weight = 0,
    MinimumSize = {274, 63},
    ReadOnly = true,
    Flat = true,
    Alignment = { AlignHCenter = false, AlignTop = true, },
    Text = '<img src="data:image/png;base64,'
    ..'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'
    ..'">',
  }
end



return ui
