describe HomesEngland::UseCase::PopulateBaselineSpec do
  let(:use_case) { described_class.new(find_project: find_project, pcs_gateway: pcs_gateway)}

  context 'example 1' do
    let(:find_project) do
      spy(
        execute: {
          name: "A project",
          type: "HIF",
          data: {},
          status: "Draft"
        }
      )
    end

    let(:pcs_gateway) do
      spy(
        get_project: HomesEngland::Domain::PcsProject.new.tap do |p|
          p.project_manager = "Michael"
          p.sponsor = "MSPC"
        end
      )
    end

    it 'calls the pcs gateway' do
      use_case.execute(project_id: 1)
      expect(pcs_gateway).to have_received(:get_project).with(project_id: 1)
    end

    it 'calls the find_project' do
      use_case.execute(project_id: 1)
      expect(find_project).to have_received(:execute).with(id: 1)
    end

    it 'sets the relevant data' do
      data = use_case.execute(project_id: 1)
      expect(data).to eq({
        name: "A project",
        type: "HIF",
        data: {
          summary: {
            ProjectManager: "Michael",
            Sponsor: "MSPC"
          }
        },
        status: "Draft"
      })
    end
  end

  context 'example 2' do
    let(:find_project) do
      spy(
        execute: {
          name: "Another project",
          type: "AC",
          data: {
            summary: {
              description: "An important project",
              misc: {}
            }
          },
          status: "Draft"
        }
      )
    end

    let(:pcs_gateway) do
      spy(
        get_project: HomesEngland::Domain::PcsProject.new.tap do |p|
          p.project_manager = "Aaron"
          p.sponsor = "LZMA"
        end
      )
    end

    it 'calls the pcs gateway' do
      use_case.execute(project_id: 13)
      expect(pcs_gateway).to have_received(:get_project).with(project_id: 13)
    end

    it 'calls the find_project' do
      use_case.execute(project_id: 13)
      expect(find_project).to have_received(:execute).with(id: 13)
    end

    it 'sets the relevant data' do
      data = use_case.execute(project_id: 1)
      expect(data).to eq({
        name: "Another project",
        type: "AC",
        data: {
          summary: {
            description: "An important project",
            misc: {},
            ProjectManager: "Aaron",
            Sponsor: "LZMA"
          }
        },
        status: "Draft"
      })
    end
  end
end
