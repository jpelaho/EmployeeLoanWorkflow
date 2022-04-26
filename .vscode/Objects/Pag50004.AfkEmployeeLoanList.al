page 50004 AfkEmployeeLoanList
{
    Caption = 'Employee Loan List';
    PageType = List;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Report,Approbation,Release,Request Approval,Loan';
    UsageCategory = Lists;
    SourceTable = AfkEmployeeLoan;
    CardPageId = AfkEmployeeLoanCard;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = All;
                }
                field("Loan Reason"; Rec."Loan Reason")
                {
                    ApplicationArea = All;
                }
                field("Duration"; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Loan Amount (LCY)"; Rec."Loan Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Create By"; Rec."Create By")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit AfkEmpLoanWorkflowMgt;
                begin
                    ApprovalsMgmt.OpenApprovalsEmplLoan(Rec);
                end;

            }
        }
        area(Processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                //Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = All, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval of the document.';
                    Promoted = true;
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    Enabled = NOT OpenApprovalEntriesExist;
                    trigger OnAction()
                    var
                        EmpLoanWkflMgt: Codeunit AfkEmpLoanWorkflowMgt;
                    begin
                        IF EmpLoanWkflMgt.CheckEmployeeLoanApprovalPossible_AFK(Rec) THEN;
                        EmpLoanWkflMgt.OnSendEmployeeLoanForApproval_AFK(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = All, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = true;
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    PromotedCategory = Category6;
                    Enabled = CanCancelApprovalForRecord;
                    trigger OnAction()
                    var
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                        EmpLoanWkflMgt: Codeunit AfkEmpLoanWorkflowMgt;
                    begin
                        EmpLoanWkflMgt.OnCancelEmployeeLoanApprovalRequest_AFK(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RECORDID);
                    end;
                }
            }
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                    begin
                        Rec.PerformManualRelease();
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                    begin
                        Rec.PerformManualReOpen();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin

    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
    end;



    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;

}