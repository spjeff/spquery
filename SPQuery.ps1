<#
.SYNOPSIS
	GUI to run SQL query across all content databases

.DESCRIPTION
	Simple GUI to loop a given SQL query across all local SharePoint farm content databases. Grid view 
	results can be copy/pasted to Excel.  Form contains two buttons - Run and Save.  Run will execute a 
	query across all databases.  Save generates a XML file with all results.  This is useful for large 
	result sets that are too big to copy/paste with clipboard.
	
	Can be useful with support and troubleshooting to identify the scope, usage, and instances for a given
	feature or configuration setting.   Use with caution as direct SQL database query is not supported.  
	Recommend using "NOLOCK" hint on all queries and running after business hours.

	Comments and suggestions always welcome!  spjeff@spjeff.com or @spjeff

.NOTES
	File Name		: SPQuery.ps1
	Author			: Jeff Jones - @spjeff
	Version			: 1.0
	Last Modified	: 04-18-2016
.LINK
	https://github.com/spjeff/spquery
#>

# Plugins
[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue | Out-Null
Import-Module SQLPS -ErrorAction SilentlyContinue | Out-Null

#region GUI

# WinForm
$form = New-Object System.Windows.Forms.Form
$form.Text = 'SPQuery'
$form.Size = New-Object System.Drawing.Size(600,400)

# Query Text
$txtQuery = New-Object System.Windows.Forms.TextBox
$txtQuery.Multiline = $true
$txtQuery.WordWrap = $true
$txtQuery.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$txtQuery.Width = 400
$txtQuery.Height = 60
$txtQuery.Text = "SELECT id,fullurl,requestaccessemail FROM webs WITH (NOLOCK)"
$form.Controls.Add($txtQuery)

# Button - Run
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run Query"
$btnRun.Top = 5
$btnRun.Left = 410
$btnRun.Width = 80
$form.Controls.Add($btnRun)

# Button - Save
$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save to XML"
$btnSave.Top = 35
$btnSave.Left = 410
$btnSave.Width = 80
$form.Controls.Add($btnSave)

# Grid
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Top = 60
$dataGridView.ReadOnly = $true
$dataGridView.Size = New-Object System.Drawing.Size(500,300)
$form.Controls.Add($dataGridView)
#endregion

#region Logic

# Query SQL database
Function RunQuery() {
    $global:dt = New-Object System.Data.Datatable "SPQuery"
    $cdbs = Get-SPContentDatabase
	$counter = 0
	
	# Loop content databases
    foreach ($cdb in $cdbs) {
		# Scope
        $i = $cdb.NormalizedDataSource
        $d = $cdb.Name
		
		# Progress
		Write-Progress -Activity "Opening " -Status $d -PercentComplete (($counter/$cdbs.Count)*100)
		$counter++
		
		# Execute
        $res = Invoke-Sqlcmd -Query $txtQuery.Text -QueryTimeout 120 -ServerInstance $i -Database $d
		
		# Parse results
		if ($res) {
			$cols = $res[0] | gm |? {$_.MemberType -eq "Property"}
			if ($global:dt.Columns.Count -eq 0) {
				foreach ($c in $cols) {
					# Cols
					$global:dt.Columns.Add($c.Name) | Out-Null
				}
				$global:dt.Columns.Add("WebAppURL") | Out-Null
				$global:dt.Columns.Add("SQLInstance") | Out-Null
				$global:dt.Columns.Add("ContentDB") | Out-Null
			}
			foreach ($r in $res) {
				# Rows
				$newRow = $global:dt.NewRow()
				foreach ($c in $cols) {
					$prop = $c.Name
					$newRow[$prop] = $r[$prop]
				}
				$newRow["WebAppURL"] = $cdb.WebApplication.URL
				$newRow["SQLInstance"] = $cdb.NormalizedDataSource
				$newRow["ContentDB"] = $cdb.Name
				$global:dt.Rows.Add($newRow) | Out-Null
			}
		}
    }
	Write-Progress -Activity "Completed" -Completed
    
    # Bind
    $dataGridView.DataSource = $global:dt
    $dataGridView.Refresh()
}
# Save to XML file
Function RunSave() {
    $tmp = $env:temp
    $when = (Get-Date).ToString("yyyy-MM-dd-hh-mm-ss")
    $file = "$tmp\SPQuery-$when.xml"
    $global:dt.WriteXml($file)
    start $tmp
}
#endregion

# Resize
Function VerifySize() {
	$h = $form.Size.Height - 100
	$w = $form.Size.Width - 40
	if ($dataGridView.Size.Height -ne $h -or $dataGridView.Size.Width -ne $w) {
		$dataGridView.Size = New-Object System.Drawing.Size($w,$h)
	}
}

# Resize
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({VerifySize})
$timer.Start()

# Event Handlers
$btnRun.Add_Click({RunQuery})
$btnSave.Add_Click({RunSave})

# Init
$form.ShowDialog()