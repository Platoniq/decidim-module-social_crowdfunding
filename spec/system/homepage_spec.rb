# frozen_string_literal: true

require "spec_helper"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization, available_locales: [:en] }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
  end

  context "when there are active alternative landing content blocks" do
    let!(:cover_full_block) { create(:cover_full_block, organization: organization) }
    let!(:cover_half_block) { create(:cover_half_block, organization: organization) }
    let!(:stack_horizontal_block) { create(:stack_horizontal_block, organization: organization) }
    let!(:stack_vertical_block) { create(:stack_vertical_block, organization: organization) }
    let!(:tiles_block) { create(:tiles_block, organization: organization) }
    let!(:latest_blog_posts_block) { create(:latest_blog_posts_block, organization: organization) }
    let!(:upcoming_meetings_block) { create(:upcoming_meetings_block, organization: organization) }
    let!(:blogs_component) { create(:component, manifest_name: "blogs", organization: organization) }
    let!(:meetings_component) { create(:component, manifest_name: "meetings", organization: organization) }
    let!(:blog_posts) { create_list(:post, 6, component: blogs_component) }
    let!(:meetings) { create_list(:meeting, 6, :upcoming, component: meetings_component) }
    let!(:sorted_meetings) { meetings.sort_by(&:start_time).reverse }

    before do
      visit decidim.root_path
    end

    it "renders them" do
      expect(page).to have_selector(".alternative-landing")
      expect(page).to have_selector(".alternative-landing.cover-full")
      expect(page).to have_selector(".alternative-landing.cover-half")
      expect(page).to have_selector(".alternative-landing.stack-horizontal")
      expect(page).to have_selector(".alternative-landing.stack-vertical")
      expect(page).to have_selector(".alternative-landing.tiles-4")
      expect(page).to have_selector(".alternative-landing.latest-blog-posts")
      expect(page).to have_selector(".alternative-landing.upcoming-meetings")
    end

    describe "cover_full block" do
      it "renders all elements" do
        expect(page.find(".alternative-landing.cover-full")[:style]).to match(/#{cover_full_block.images_container.background_image.big.url}/)

        within ".alternative-landing.cover-full" do
          within ".cover-text" do
            within ".cover-title" do
              expect(page).to have_i18n_content(cover_full_block.settings.title)
            end
            within ".cover-body" do
              expect(page).to have_i18n_content(cover_full_block.settings.body)
            end
          end
        end
      end
    end

    describe "cover_half block" do
      it "renders all elements" do
        within ".alternative-landing.cover-half" do
          expect(page.find(".cover-image")[:style]).to match(/#{cover_half_block.images_container.background_image.big.url}/)

          within ".cover-text" do
            within ".cover-title" do
              expect(page).to have_i18n_content(cover_half_block.settings.title)
            end
            within ".cover-body" do
              expect(page).to have_i18n_content(cover_half_block.settings.body)
            end
          end
        end
      end
    end

    describe "stack_horizontal block" do
      it "renders all elements" do
        within ".alternative-landing.stack-horizontal" do
          expect(page).to have_i18n_content(stack_horizontal_block.settings.title)

          1.upto(3) do |item_number|
            within ".stack-item:nth-of-type(#{item_number})" do
              within ".stack-image" do
                expect(page.find("img")[:src]).to match(/#{stack_horizontal_block.images_container.send(:"image_#{item_number}").landscape.url}/)
              end

              within ".stack-body" do
                expect(page).to have_i18n_content(stack_horizontal_block.settings.send(:"body_#{item_number}"))

                within ".stack-link" do
                  expect(page).to have_link(
                    translated(stack_horizontal_block.settings.send(:"link_text_#{item_number}")),
                    href: translated(stack_horizontal_block.settings.send(:"link_url_#{item_number}"))
                  )
                end
              end
            end
          end
        end
      end
    end

    describe "stack_vertical block" do
      it "renders all elements" do
        within ".alternative-landing.stack-vertical" do
          expect(page).to have_i18n_content(stack_vertical_block.settings.title)

          1.upto(3) do |item_number|
            within ".stack-item:nth-of-type(#{item_number})" do
              within ".stack-image" do
                expect(page.find("img")[:src]).to match(/#{stack_vertical_block.images_container.send(:"image_#{item_number}").square.url}/)
              end

              within ".stack-tags" do
                expect(page).to have_link(
                  translated(stack_vertical_block.settings.send(:"tag_text_#{item_number}")),
                  href: translated(stack_vertical_block.settings.send(:"tag_url_#{item_number}"))
                )
              end

              within ".stack-body" do
                expect(page).to have_i18n_content(stack_vertical_block.settings.send(:"body_#{item_number}"))
              end

              within ".stack-link" do
                expect(page).to have_link(
                  translated(stack_vertical_block.settings.send(:"link_text_#{item_number}")),
                  href: translated(stack_vertical_block.settings.send(:"link_url_#{item_number}"))
                )
              end
            end
          end
        end
      end
    end

    describe "tiles block" do
      it "renders all elements" do
        within ".alternative-landing.tiles-4" do
          within ".tiles" do
            within ".tile-heading" do
              expect(page).to have_i18n_content(tiles_block.settings.title)
            end

            1.upto(4) do |item_number|
              expect(page.find(".tile-#{item_number}")[:style]).to match(/#{tiles_block.images_container.send(:"background_image_#{item_number}").landscape.url}/)

              within ".tile-#{item_number}" do
                within ".tile-body" do
                  expect(page).to have_i18n_content(tiles_block.settings.send(:"title_#{item_number}"))
                  expect(page).to have_i18n_content(tiles_block.settings.send(:"body_#{item_number}"))
                end
              end
            end
          end
        end
      end
    end

    describe "latest_blog_posts block" do
      it "renders all elements" do
        within ".alternative-landing.latest-blog-posts" do
          expect(page).to have_i18n_content(latest_blog_posts_block.settings.title, upcase: true)
          expect(page).to have_i18n_content(latest_blog_posts_block.settings.link_text, upcase: true)
          blog_posts.last(3).each do |blog_post|
            expect(page).to have_i18n_content(blog_post.title)
          end
          blog_posts.first(3).each do |blog_post|
            expect(page).not_to have_i18n_content(blog_post.title)
          end
        end
      end
    end

    describe "upcoming_meetings block" do
      it "renders all elements" do
        within ".alternative-landing.upcoming-meetings" do
          expect(page).to have_i18n_content(upcoming_meetings_block.settings.title, upcase: true)
          expect(page).to have_i18n_content(upcoming_meetings_block.settings.link_text, upcase: true)
          sorted_meetings.last(3).each do |meeting|
            expect(page).to have_i18n_content(meeting.title)
          end
          sorted_meetings.first(3).each do |meeting|
            expect(page).not_to have_i18n_content(meeting.title)
          end
        end
      end
    end
  end
end
