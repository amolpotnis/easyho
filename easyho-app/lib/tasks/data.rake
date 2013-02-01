# encoding: UTF-8

namespace :data do

  desc "Populate Patient Case History Sections as meta data"
  task :populate_pch_sections  => :environment do
    PchSection.create(displayname: "Chief complaint",
                      displayorder: 1)
    PchSection.create(displayname: "Associated complaints",
                      displayorder: 2)
    PchSection.create(displayname: "Personality observations",
                      displayorder: 3)
    PchSection.create(displayname: "Childhood",
                      displayorder: 4)
    PchSection.create(displayname: "Other past history",
                      displayorder: 5)
    PchSection.create(displayname: "Family history",
                      displayorder: 6)
    PchSection.create(displayname: "Physical general",
                      displayorder: 7)
    PchSection.create(displayname: "Physical examination",
                      displayorder: 8)
    PchSection.create(displayname: "Mental characteristics",
                      displayorder: 9)
    PchSection.create(displayname: "Diagnosys",
                      displayorder: 10)
    PchSection.create(displayname: "Miasmatic understanding",
                      displayorder: 11)
    PchSection.create(displayname: "Repertorization and comments",
                      displayorder: 12)
    PchSection.create(displayname: "Prescribed medicines",
                      displayorder: 13)
  end
  # -----------------------------------------------------------------------
end