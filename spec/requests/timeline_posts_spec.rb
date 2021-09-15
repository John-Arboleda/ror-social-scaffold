require 'rails_helper'

RSpec.describe 'See friend\'s posts', type: :feature do
    let(:sender) { User.create(id: 1, name: 'LeBron-James', email: 'lbj@gmail.com', password: '123456') }
    let(:receiver) { User.create(id: 2, name: 'John', email: 'john@gmail.com', password: '123456') }
  
    scenario 'I can\'t see non-friend\'s post in my timeline' do
        visit new_user_session_path
        fill_in 'Email', with: sender.email
        fill_in 'Password', with: sender.password
        click_on 'Log in'
        sleep(1)
        fill_in 'post_content', with: 'You can\'t see this post'
        click_on 'Save'
        sleep(1)
        click_link 'Sign out'
        sleep(1)
        visit new_user_session_path
        fill_in 'Email', with: receiver.email
        fill_in 'Password', with: receiver.password
        click_on 'Log in'
        sleep(1)
        visit root_path
        expect(page).not_to have_content('You can\'t see this post')
    end
    
    scenario 'I can see friend\'s post in my timeline' do
        visit new_user_session_path
        fill_in 'Email', with: sender.email
        fill_in 'Password', with: sender.password
        click_on 'Log in'
        sleep(1)
        click_link 'Sign out'
        sleep(1)
        visit new_user_session_path
        fill_in 'Email', with: receiver.email
        fill_in 'Password', with: receiver.password
        click_on 'Log in'
        sleep(1)
        fill_in 'post_content', with: 'My friend can see this post'
        click_on 'Save'
        sleep(1)
        visit '/users/1'
        click_link '| Invite to Friendship'
        sleep(1)
        click_link 'Sign out'
        sleep(1)
        visit new_user_session_path
        fill_in 'Email', with: sender.email
        fill_in 'Password', with: sender.password
        click_on 'Log in'
        sleep(1)
        visit '/users/2'
        click_link '| Accept Friendship'
        sleep(1)
        visit root_path
        expect(page).to have_content('My friend can see this post')
    end
end