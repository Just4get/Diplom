//
//  ResultItem.swift
//  Diplom
//
//  Created by BigDude6 on 08/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import Foundation

class ResultItem {
    let type:TestTypes
    let time: Double
    var description: String
    let mistakes: Int

    static func TestName(type:TestTypes) ->String{
        switch type {
        case .Colors:
            return "Внимательность"
        case .Gorbov:
            return "Переключение внимания"
        case .Ilyin:
            return "Выносливость нервной системы"
        case .MemoryCard:
            return "Память"
        case .Shulte:
            return "Устойчивость внимания"
        case .Raven:
            return "Восприятие форм"
        case .Yarockiy:
            return "Чувствительность вестибулярного аппарата"
        }
    }
    
    static func TestVCID(type:TestTypes) -> String {
        let enumValue = String(describing: type)
        return enumValue
    }
    
    var Recommendation:String {
        var result = ""
        switch type {
        case .Colors:
            result = "Значения показателя в норме. Упражнения или рекомендации не требуются"
            if mistakes < 7 {
                result = "Значение показтеля ниже нормы. Вам может помочь следующее упражнение :\nОдновременно рассматривайте два предмета, отмечая про себя детали каждого из них. Смысл такого задания заключается в расширении объема и правильном распределении внимания. Можно увеличить количество рассматриваемых предметов, повысив тем самым уровень сложности упражнения"
            }
            
        case .Gorbov:
            var points = 0
            switch time {
            case 0...70:
                points = 5
            case 71...110:
                points = 4
            case 111...180:
                points = 3
            case 181...220:
                points = 2
            default:
                points = 1
            }
            if mistakes > 4 {
                points -= 1
            }
            switch points {
            case 5:
                result = "У вас отличный уровень переключения внимания, упражнения не требуются"
            case 4:
                result = "У вас хороший уровень переключения внимания, упражнения не требуются"
            case 3:
                result = "Ваш  уровень переключения внимания в пределах нормы, упражнения не требуются"
            case 0...2:
                result = "Значение показтеля ниже нормы.\nДля улучшения этого показателя вы можете воспользоваться упражнениями, основанные на эффекте Струпа"
            default:
                result = "BAD RESULTS POINTS is \(points)"
            }
            
        case .Ilyin:
            switch description {
            case "Strong":
                result = "У вас сильный тип нервной системы, упражнения не требуются"
            case "Weak":
                result = "У вас слабый тип нервной системы. Слабая нервная система выдерживает меньшую по величине и длительности нагрузку, чем сильная. Для улучшения нервной системы. Ежедневные прогулки или пробежки помогут укрепить вам нервную систему. Также может помочь посещение бассейна. Правильное питание – это еще один из действенных способов укрепления нервной системы."
            case "Middle":
                result = "У вас средний тип нервной системы, упражнения не требуются"
            default:
                result = "У вас средне-слабый тип нервной системы, упражнения не требуются. Для улучшения нервной системы вам может помочь правильное питане и здоровый сон."
            }

            return result
            
        case .MemoryCard:
            switch mistakes {
            case 0...26:
                result = "Значение показтеля в норме. Вы обладаете хорошей памятью. Упражнения не требуются"
            default:
                result = """
                Значения показателя ниже нормы.
                Для улучшения мозгового кровообращения, а следовательно, и для развития памяти, будут очень полезны следующие физические упражнения: бег трусцой,ходьба(регулярно), катание на велосипеде или занятия на велотренажере.
                Если вам предстоит запоминать большой объем информации или вам необходимо длительное время работать с документами, каждый час делайте небольшие перерывы. В эти перерывы разминайтесь: наклоны в стороны и вперед-назад, разминка шеи, повороты головы, махи руками помогут вам активизировать кровообращение и улучшить внимательность.
                """
            }
            return result
            
        case .Raven:
            //TODO
            return ""
            
        case .Shulte:
            if time < 1 {
                result = "Ваш показатель психической устойчивости равен \(time). Если этот показатель меньше 1, то это означает, что вы обладаете хорошей психической устойчивостью. Вам не требуются какие либо физические упражнения."
            }
            else
            {
                //TODO:  дополнить
                result = "Ваш показатель психической устойчивости равен \(time). Если показатель превышает 1, то это свидетельствует о плохой способности долго концентрироваться на какой-либо деятельности."
            }

            return result
        case .Yarockiy:
            switch time {
            case 0...23:
                result = "У вас низкий показатель. Рекоммендуемые упражнения:\n1.Сохранять равновесие, стоя на одной ноге в течение минуты, руки разведены в стороны. Голова поворачивается то влево, то вправо. Взгляд не фиксируется и не помогает сохранять равновесие. С развитием навыка закрыть глаза.\n2. Стоя на одной ноге, подпрыгнуть и приземлится на другую ногу. Следующее подпрыгивание - приземление на исходную позицию. Выполняется в течении нескольких минут"
            case 23...31:
                result = "Данный показатель средний результат. Данный результат характерен для нетренированных людей."
            case 32...300:
                result = "Вы показали хороший результат. Данный результат характерен для тренированных людей или спортсменов."
            default:
                result = "Время огромное"
                return ""
            }
            
        }
        return result
    }

    
    init(type: TestTypes, time: Double, description: String, mistakes: Int) {
        self.type = type
        self.time = time
        self.description = description
        self.mistakes = mistakes
    }
    
}
