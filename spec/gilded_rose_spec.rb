require "spec_helper"
require "./lib/gilded_rose"

RSpec.describe GildedRose do
  let(:name) { 'Normal Item' }
  subject(:gilded_rose) { GildedRose.new }

  it "is a gilded rose" do
    expect(gilded_rose).to be_a(GildedRose)
  end

  describe '#tick' do
    context 'normal item after sell date' do
      let(:gr) { GildedRose.new(name: "Normal Item", days_remaining: -10, quality: 10) }

      it 'decreases the quality by 2' do
        gr.tick
        expect(gr).to have_attributes(days_remaining: -11, quality: 8)
      end
    end

    context "normal item before sell date" do
      let(:gr) { GildedRose.new(name: "Normal Item", days_remaining: 5, quality: 10) }

      it 'decreases the quality by 1' do
        gr.tick
        expect(gr).to have_attributes(days_remaining: 4, quality: 9)
      end
    end

    context "normal item on sell date" do
      let(:gr) { GildedRose.new(name: "Normal Item", days_remaining: 0, quality: 10) }
      it 'decreases the quality by 2' do
        gr.tick
        expect(gr).to have_attributes(days_remaining: -1, quality: 8)
      end
    end

    context "normal item of zero quality" do
      let(:gr) { GildedRose.new(name: name, days_remaining: 5, quality: 0) }
      it 'does not decrease the quality' do
        gr.tick
        expect(gr).to have_attributes(days_remaining: 4, quality: 0)
      end
    end

    context 'aged brie' do
      context 'before sell date' do
        context 'low quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: 5, quality: 10) }
          it 'increases the quality by 1' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: 4, quality: 11)
          end
        end
        context 'max quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: 5, quality: 50) }
          it 'does not increase the quality' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: 4, quality: 50)
          end
        end
      end

      context 'on sell date' do
        context 'low quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: 0, quality: 10) }
          it 'increases the quality by 2' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: -1, quality: 12)
          end
        end
        context 'high quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: 0, quality: 49) }
          it 'increases the quality by 1' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: -1, quality: 50)
          end
        end
        context 'max quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: 0, quality: 50) }
          it 'does not increase the quality' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: -1, quality: 50)
          end
        end
      end

      context 'after sell date' do
        context 'low quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: -10, quality: 10) }
          it 'increases the quality by 2' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: -11, quality: 12)
          end
        end
        context 'max quality' do
          let(:gr) { GildedRose.new(name: "Aged Brie", days_remaining: -10, quality: 50) }
          it 'does not increase the quality' do
            gr.tick
            expect(gr).to have_attributes(days_remaining: -11, quality: 50)
          end
        end
      end
    end
  end

  it "sulfuras before sell date" do
    gr = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 5, quality: 80)

    gr.tick

    expect(gr.days_remaining).to eq(5)
    expect(gr.quality).to eq(80)
  end

  it "sulfuras on sell date" do
    gr = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 0, quality: 80)

    gr.tick

    expect(gr.days_remaining).to eq(0)
    expect(gr.quality).to eq(80)
  end

  it "sulfuras after sell date" do
    gr = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: -10, quality: 80)

    gr.tick

    expect(gr.days_remaining).to eq(-10)
    expect(gr.quality).to eq(80)
  end

  it "backstage passes long before sell date" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 11, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(10)
    expect(gr.quality).to eq(11)
  end

  it "backstage passes long before sell date at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 11, quality: 50)

    gr.tick

    expect(gr).to have_attributes(days_remaining: 10, quality: 50)
  end

  it "backstage passes medium close to sell date upper bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(9)
    expect(gr.quality).to eq(12)
  end

  it "backstage passes medium close to sell date upper bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(9)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes medium close to sell date lower bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(5)
    expect(gr.quality).to eq(12)
  end

  it "backstage passes medium close to sell date lower bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(5)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes very close to sell date upper bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(13)
  end

  it "backstage passes very close to sell date upper bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes very close to sell date lower bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 1, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(0)
    expect(gr.quality).to eq(13)
  end

  it "backstage passes very close to sell date lower bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 1, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(0)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes on sell date" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 0, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(0)
  end

  it "backstage passes after sell date" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: -10, quality: 10)
#
    gr.tick

    expect(gr.days_remaining).to eq(-11)
    expect(gr.quality).to eq(0)
  end

  xit "conjured mana before sell date" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 5, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(8)
  end

  xit "conjured mana before sell date at zero quality" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 5, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(0)
  end

  xit "conjured mana on sell date" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 0, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(6)
  end

  xit "conjured mana on sell date at zero quality" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 0, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(0)
  end

  xit "conjured mana after sell date" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: -10, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(-11)
    expect(gr.quality).to eq(6)
  end

  xit "conjured mana after sell date at zero quality" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: -10, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(-11)
    expect(gr.quality).to eq(0)
  end
end
