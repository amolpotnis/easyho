# encoding: UTF-8

namespace :data do

  desc "Populate Patient Case History Sections as meta data"
  task :populate_pch_sections  => :environment do
    PchSection.create(displayname: "Chief complaint",
                      sec_id: 1)
    PchSection.create(displayname: "Associated complaints",
                      sec_id: 2)
    PchSection.create(displayname: "Personality observations",
                      sec_id: 3)
    PchSection.create(displayname: "Childhood",
                      sec_id: 4)
    PchSection.create(displayname: "Other past history",
                      sec_id: 5)
    PchSection.create(displayname: "Family history",
                      sec_id: 6)
    PchSection.create(displayname: "Physical general",
                      sec_id: 7)
    PchSection.create(displayname: "Physical examination",
                      sec_id: 8)
    PchSection.create(displayname: "Mental characteristics",
                      sec_id: 9)
    PchSection.create(displayname: "Diagnosys",
                      sec_id: 10)
    PchSection.create(displayname: "Miasmatic understanding",
                      sec_id: 11)
    PchSection.create(displayname: "Repertorization and comments",
                      sec_id: 12)
    PchSection.create(displayname: "Prescribed medicines",
                      sec_id: 13)
  end
  # -----------------------------------------------------------------------
end